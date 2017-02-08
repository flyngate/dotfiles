#!/usr/bin/env bash

repo=https://github.com/flyngate/dotfiles
default_recipe="default.recipe"

self_name=$(basename $0)
current_dir=$(cd $(dirname $BASH_SOURCE[0]); pwd)
home_dir="$current_dir/_home"  # $HOME
backup_dir="$current_dir/_dotfiles_backup"

mkdir -p "$home_dir"  # TODO: remove

packages=()
flag_copy=false
flag_verbose=false
flag_remote=false
flag_child=false

print_info() {
  echo -e "\033[0;32m INFO\033[0m  $1"
}

print_error() {
  local err=${1:-ERROR}
  echo -e "\033[0;31m ERROR\033[0m $err"
}

print_question() {
  echo -e "\033[0;33m QUEST\033[0m $1"
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

array_contains () {
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

# symlink or copy package into home directory
install() {
  local package="$1"

  IFS=$'\n'
  for file in $(cd $1; find .); do
    file="${file:2}"
    [[ -n $file ]] || continue

    local src="$current_dir/$package/$file"
    local dst="$home_dir/$file"
    local backup=$(dirname "$backup_dir/$file")

    if [[ -d "$src" ]]; then
      verbose "  mkdir $dst"
      mkdir -p "$dst"
    else
      if [[ -L "$dst" ]]; then
        rm $dst
      elif [[ -f "$dst" ]]; then
        verbose "  backup $(basename file) into $backup"
        mkdir -p "$backup"
        mv "$dst" "$backup"
      fi

      if [[ "$2" == false ]]; then
        verbose "  symlink $file into $dst"
        ln -s "$src" "$dst"
      else
        verbose "  copy $file into $dst"
        cp "$src" "$dst"
      fi
    fi
  done
  unset IFS
}

add_package() {
  package_name="$1"
  package_path="$current_dir/$package_name"

  if ! array_contains "$package_name" "${packages[@]}"; then
    if [[ -e "$package_path" ]]; then
      packages+=($package_name)
    else
      abort "Package $package_name doesn't exists"
    fi
  fi
}

add_recipe() {
  recipe_path="$current_dir/$1"

  if [[ -e "$recipe_path" ]]; then
    recipe_packages=($(source $recipe_path; echo ${PACKAGES[@]}))
    for recipe_package in "${recipe_packages[@]}"; do
      add_package "$recipe_package"
    done
  else
    abort "Recipe $1 doesn't exist"
  fi
}

remote() {
  # take out --remote argument
  local args=()
  for arg in "$@"; do
    [[ "$arg" != '-r' && "$arg" != '--remote' ]] && args+=($arg)
  done

  # use either wget or curl
  [[ -x `command -v wget` ]] && fetch="wget --no-check-certificate -O -"
  [[ -x `command -v curl` ]] >/dev/null 2>&1 && fetch="curl -#L"

  # fetch repository and run ./install.sh on it
  if [ -z "$fetch" ]; then
    print_error "No curl or wget available. Aborting."
  else
    tmp_dir=$(mktemp -d)
    trap "print_info Cleanup; rm -rf $tmp_dir" EXIT SIGINT SIGTERM
    print_info "Fetch repository into $tmp_dir..."
    $fetch "$repo/tarball/master" | tar -xzv -C $tmp_dir --strip-components=1 > /dev/null
    "$tmp_dir/$self_name" "${args[@]}" --copy --child || print_error
  fi

  exit 1
}

for arg in "$@"; do
  if [[ $arg == "-"* ]]; then
    case $arg in
      "-c" | "--copy"  )   flag_copy=true ;;
      "-v" | "--verbose" ) flag_verbose=true ;;
      "-r" | "--remote" )  flag_remote=true ;;
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

[[ "$flag_remote" == true ]] && remote "$@"

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

for package in ${packages[@]}; do
  print_info "$([[ "$flag_copy" == true ]] && echo "Copy" || echo "Symlink") $package"
  install $package $flag_copy
done

print_info "Done"
