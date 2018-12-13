# will setup everything for demonstration in vagrant
all: distributor genode binaries #datageneration
	# should clone all the repos and build an operating system for pbxa9, then should vagrant up
	make vagrant

distributor: taskgen
	# should clone the distributor_service repo and install dependencies (including the taskgen)
	@git submodule update --init --remote distributor_service
	# todo install dependencies in pyenv

taskgen:
	# should clone taskgen repo and install dependencies
	@git submodule update --init --remote taskgen
	# todo install dependencies in pyenv

datageneration:
	# should clone datageneration and install dependencies
	@git submodule update --init --remote datageneration
	# todo install dependencies in pyenv

genode: 
	# should clone operating system and build genode for specified arg
	@git submodule update --init --remote operating-system
	cd operating-system; make packages

binaries:#takes target as arg
	# should build operating system and taskbinaries and put them into the bin folder in client-tools
	cd operating-system; ./setup.sh focnados_pbxa9 # should take target

vagrant:
	@vagrant up
	@vagrant ssh

#dependencies: dependencies-confirm
	#should install the dependencies for the whole setup in pyenv

#dependencies-confirm:
	#@( read -p "This will install qemu12, bridge-utils, screen, isc-dhcp-server, htop, pkg-config, zlib1g-dev, libglib2.0, libpixman-1.0, libpixman-1-dev Are you sure?!? [Y/n]: " sure && case "$$sure" in [nN]) false;; *) true;; esac )
