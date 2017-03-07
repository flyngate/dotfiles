## EXAMPLES

**Install default.recipe**

	$ ./install.sh

**Install specific recipe**

	$ ./install.sh macos.recipe

**Install package**

	$ ./install.sh git

**Multiple targets at once**

	$ ./install.sh default.recipe macos.recipe git

**Copy instead of making symlinks**

	$ ./install.sh git -c

**Provide verbose output**

	$ ./install.sh -v

## REMOTE

Run one of the following commands on remote machine. This approach creates only copies, not symlinks, in home directory.

*curl*

	$ sh -c "`curl -fsSL https://raw.github.com/flyngate/dotfiles/master/install.sh -r [ARGUMENTS]`"

*wget*

	$ sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/flyngate/dotfiles/master/install.sh -r [ARGUMENTS]`"


Packages
========


### zsh

* Completion
	- [Docker](https://github.com/docker/docker/blob/master/contrib/completion/zsh/_docker)
	- [OpenSSL, MacPorts, Fabric, Ansible, PostgreSQL](https://github.com/zsh-users/zsh-completions)
	- [Django and much more](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins) repository.
