# will setup everything for demonstration in vagrant
all: 
	# should clone all the repos and build an operating system for pbxa9, then should vagrant up 
	-make venv
	make distributor-init
	make genode-init
	make binaries OS-TARGET=focnados_pbxa9
	make datageneration
	#-make packages
	-make vagrant

distributor-init: taskgen-init
	# clones the distributor_service repo and installs dependencies in venv(including the taskgen)
	@-make venv
	@git submodule update --init --remote distributor
	@-bash -c "source malsami/bin/activate; pip3 install -r ./distributor/requirements.txt > /dev/null ; deactivate"

taskgen-init:
	# should clone taskgen repo, there are no dependencies
	@git submodule update --init --remote taskgen

datageneration-init:
	# clones datageneration and installs dependencies in venv
	@-make venv
	@git submodule update --init --remote datageneration
	@-bash -c "source malsami/bin/activate; pip3 install -r ./datageneration/requirements.txt > /dev/null ; deactivate"

genode-init: 
	# should clone operating system and build genode for specified arg
	@git submodule update --init --remote operating-system
	cd operating-system; make packages

binaries:
	# TARGET=focnados_pbxa9, focnados_panda, focnados_...
	# should build operating system and taskbinaries and put them into ./bin
ifdef OS-TARGET
	cd operating-system; ./setup.sh $(OS-TARGET)
else
	@echo "there was no target, provide one via 'OS-TARGET=...'"
endif

venv: notInVagrant
	#this installs python3-venv (if not already installed) and creates a venv called malsami
	make install-PKG PKG=python3-venv ASK=NO
	python3 -m venv malsami
	@bash -c "source malsami/bin/activate; pip3 install --upgrade pip ; deactivate"

inVagrant:
	# is successful if user is vagrant or ubuntu
	@if [ $(USER) = "ubuntu" ] || [ $(USER) = "vagrant" ]; then \
		true; \
	else \
		false; \
	fi

notInVagrant:
	# is successful if NOT in the directory /vagrant
	@PATH=$$(pwd); \
	if [ "$$PATH" = "/vagrant" ]; then \
		false; \
	else \
		true; \
	fi

vagrant: notInVagrant
	# installs vagrant (if not already installed) and starts the vagrant machine and logs into it
	make install-PKG PKG=vagrant ASK=NO
	vagrant up
	vagrant ssh

install-PKG: install-PKG-confirm
ifdef PKG
	@PKG_IS_INSTALLED=$$(dpkg-query -W --showformat='$${Status}\n' $(PKG)|grep "install ok installed"); \
	if [ -z "$$PKG_IS_INSTALLED" ]; then  \
		echo "$(PKG) is not installed yet, will install ..."; \
		sudo apt-get --force-yes --yes install $(PKG); \
	else \
		echo "$(PKG) is already installed"; \
	fi
else
	@echo "PKG missing, declare package like PKG='package'"
endif

install-PKG-confirm:
	#asks for permission to install if ASK is not YES
ifdef PKG
ifeq ($(ASK), YES)
	@( read -p "This will install $(PKG) Are you sure?!? [Y/n]: " sure && case "$$sure" in [nN]) false;; *) true;; esac )
else
	true
endif
else
	@echo "PKG missing, declare package like PKG='package'"
	false
endif

packages: notInVagrant
	sudo apt-get update -qq 
	@for pkg in python3.5 python3-pip bridge-utils screen isc-dhcp-server htop pkg-config zlib1g-dev libglib2.0 libpixman-1.0 libpixman-1-dev; do \
		echo "$$pkg"; \
		make install-PKG PKG="$$pkg" ASK=NO ; \
	done

#dependencies: dependencies-confirm
	#should install the dependencies for the whole setup in pyenv

#dependencies-confirm:
	#@( read -p "This will install qemu12, bridge-utils, screen, isc-dhcp-server, htop, pkg-config, zlib1g-dev, libglib2.0, libpixman-1.0, libpixman-1-dev Are you sure?!? [Y/n]: " sure && case "$$sure" in [nN]) false;; *) true;; esac )
