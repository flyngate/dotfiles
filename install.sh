#!/bin/bash

set -e

repo=https://github.com/flyngate/dotfiles
default_recipe="default.recipe"

current_dir=$(cd $(dirname $BASH_SOURCE[0]); pwd)
home_dir=$HOME
backup_dir="$home_dir/.dotfiles_backup"

packages=()
flag_copy=false
flag_verbose=false
flag_remote=false
flag_dry=false
flag_child=false

print_info() {
  printf "\033[0;32m INFO\033[0m  $1\n"
}

print_error() {
  local err=${1:-ERROR}
  printf "\033[0;31m ERROR\033[0m $err\n"
}

print_warn() {
  printf "\033[0;33m WARN\033[0m  $1\n"
}

verbose() {
  if [[ "$flag_verbose" == true ]]; then
    print_info "$1"
  fi
}

abort() {
  print_error "$1"
  exit 1
}

array_contains() {
  local seeking=$1; shift
  local contains=1
  for element; do
    if [[ $element == $seeking ]]; then
      contains=0
      break
    fi
  done
  return $contains
}

# symlink or copy a package into home directory
install() {
  IFS=$'\n'

  local package="$1"
  local package_path="$current_dir/$package"
  local files=$(cd "$package_path"; find .)

  for file in $files; do
    file="${file:2}"
    [[ -n "$file" ]] || continue

    local src="$current_dir/$package/$file"
    local dst="$home_dir/$file"
    local backup=$(dirname "$backup_dir/$file")

    if [[ -d "$src" ]]; then
      verbose "  mkdir $dst"

      if [[ "$flag_dry" == false ]]; then
        mkdir -p "$dst"
      fi
    else
      if [[ -L "$dst" ]]; then
        verbose "  rm $dst"

        if [[ "$flag_dry" == false ]]; then
          rm "$dst"
        fi
      elif [[ -f "$dst" ]]; then
        verbose "  backup $(basename file) into $backup"

        if [[ "$flag_dry" == false ]]; then
          mkdir -p "$backup"
          mv "$dst" "$backup"
        fi
      fi

      if [[ "$2" == false ]]; then
        verbose "  symlink $file into $dst"

        if [[ "$flag_dry" == false ]]; then
          ln -s "$src" "$dst"
        fi
      else
        verbose "  copy $file into $dst"

        if [[ "$flag_dry" == false ]]; then
          cp "$src" "$dst"
        fi
      fi
    fi
  done

  unset IFS
}

add_package() {
  local package="$1"
  local package_path="$current_dir/$package"

  if ! array_contains "$package" "${packages[@]}"; then
    if [[ -e "$package_path" ]]; then
      packages+=($package)
    else
      abort "Package \"$package\" doesn't exist"
    fi
  fi
}

add_recipe() {
  local recipe="$1"
  local recipe_path="$current_dir/$1"

  if [[ -e "$recipe_path" ]]; then
    recipe_packages=($(source $recipe_path; echo ${PACKAGES[@]}))
    for recipe_package in "${recipe_packages[@]}"; do
      add_package "$recipe_package"
    done
  else
    abort "Recipe \"$recipe\" doesn't exist"
  fi
}

remote() {
  if [[ -x `command -v curl` ]] >/dev/null 2>&1; then
    fetch="curl -fL --no-progress-meter"
  elif [[ -x `command -v wget` ]]; then
    fetch="wget --no-check-certificate -qO -"
  else
    abort "Can't find curl or wget"
  fi

  tmp_dir=$(mktemp -d)
  trap "print_info Cleanup; rm -rf $tmp_dir" EXIT SIGINT SIGTERM

  print_info "Fetch repository into $tmp_dir..."
  $fetch "$repo/tarball/master" | tar -xzv -C $tmp_dir --strip-components=1 > /dev/null

  "$tmp_dir/install.sh" $@ --copy --child
}

if [[ -z "${BASH_SOURCE[0]}" ]]; then
  remote "$@"
  exit 0
fi

for arg in "$@"; do
  if [[ $arg == "-"* ]]; then
    case $arg in
      "-c" | "--copy"  )   flag_copy=true ;;
      "-v" | "--verbose" ) flag_verbose=true ;;
      "-d" | "--dry-run" ) flag_dry=true ;;
      "--child" )          flag_child=true ;;
      * ) abort "Unknown argument: $arg" ;;
    esac
  fi
done

[[ "$flag_child" == false ]] && cat <<EOF
        ___     ___      ___
      {o,o}   {o.o}    {o,o}
      |)__)   |)_(|    (__(|
      --"-"-----"-"------"-"--
        flyngate, dotfiles

Repository: $repo
Home Directory: $home_dir
Backup Directory: $backup_dir

EOF

# parse command line options
for arg in "$@"; do
  if [[ $arg != "-"* ]]; then
    if [[ $arg == *".recipe" ]]; then
      add_recipe "$arg"
    else
      add_package "$arg"
    fi
  fi
done

if [[ ${#packages[@]} == "0" ]]; then
  add_recipe "$default_recipe"
fi

if [[ "$flag_dry" == true ]]; then
  print_warn "Dry-run mode is enabled"
fi

for package in ${packages[@]}; do
  print_info "$([[ "$flag_copy" == true ]] && echo "Copy" || echo "Symlink") $package"
  install $package $flag_copy
done

print_info "Done"
