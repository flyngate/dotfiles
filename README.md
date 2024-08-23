## Installation

**Install default.recipe**

    $ ./install.sh

**Install specific recipe**

    $ ./install.sh macos.recipe

**Install package**

    $ ./install.sh git

**Multiple targets**

    $ ./install.sh default.recipe macos.recipe git

**Copy instead of making symlinks**

    $ ./install.sh -c git

**Provide verbose output**

    $ ./install.sh -v

## Install dotfiles without git

This approach doesn't support symlinks. `install.sh` would create copies of all files as if the `-c` flag was specified.

**Install default.recipe**

    $ curl -fL --no-progress-meter https://raw.github.com/flyngate/dotfiles/master/install.sh | bash
    $ wget -qO - --no-check-certificate https://raw.githubusercontent.com/flyngate/dotfiles/master/install.sh | bash

**Pass arguments to `install.sh`**

    $ curl -fL --no-progress-meter https://raw.github.com/flyngate/dotfiles/master/install.sh | bash -s -- macos.recipe
    $ wget -qO - --no-check-certificate https://raw.githubusercontent.com/flyngate/dotfiles/master/install.sh | bash -s -- macos.recipe
