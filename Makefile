.PHONY: all clean help deep_clean

help:
	@echo 'Build directives (can be overrided by environment variables'
	@echo 'or by command line parameters):'
	@echo '  SOURCE_DIR:       $(SOURCE_DIR)'
	@echo '  BUILD_DIR:        $(BUILD_DIR)'
	@echo '  LOCAL_MIRROR:     $(LOCAL_MIRROR)'
	@echo '  YUM_REPOS:        $(YUM_REPOS)'
	@echo '  MIRROR_CENTOS:    $(MIRROR_CENTOS)'
	@echo '  EXTRA_RPM_REPOS:  $(EXTRA_RPM_REPOS)'
	@echo '  EXTRA_DEB_REPOS:  $(EXTRA_DEB_REPOS)'
	@echo '  ISO_DIR/ISO_NAME: $(ISO_PATH)'
	@echo '  ENV_NAME:         $(ENV_NAME)'
	@echo '  KSYAML:           $(KSYAML)'
	@echo
	@echo 'Available targets:'
	@echo '  all  - build product'
	@echo '  iso  - build iso image'
	@echo '  clean - remove build directory and resetting .done flags'
	@echo '  deep_clean - clean + removing $(LOCAL_MIRROR) directory'
	@echo
	@echo 'To build system using one of the proprietary mirrors use '
	@echo 'the following commands:'
	@echo
	@echo 'Saratov office (default):'
	@echo 'make iso'
	@echo
	@echo 'Moscow office:'
	@echo 'make iso USE_MIRROR=msk'
	@echo
	@echo 'Custom location:'
	@echo 'make iso YUM_REPOS=proprietary MIRROR_CENTOS=http://<your_mirror>/centos'
	@echo
	@echo 'Extra RPM repos:'
	@echo 'make iso EXTRA_RPM_REPOS="<repo1_name>,http://<repo1> <repo2_name>,ftp://<repo2>"'
	@echo
	@echo 'Extra DEB repos:'
	@echo 'make iso EXTRA_DEB_REPOS="http://<repo1>/ubuntu /|ftp://<repo2> precise main"'
	@echo

# Path to the sources.
# Default value: directory with Makefile
SOURCE_DIR?=$(dir $(lastword $(MAKEFILE_LIST)))
SOURCE_DIR:=$(abspath $(SOURCE_DIR))

all: iso

clean:
	sudo rm -rf $(BUILD_DIR)
deep_clean: clean
	sudo rm -rf $(LOCAL_MIRROR)

vbox-scripts:
	echo "Target is deprecated. Virtualbox scripts have been moved to http://git.openstack.org/openstack/fuel-virtualbox.git"

# Common configuration file.
include $(SOURCE_DIR)/config.mk

.PHONY: current-version
current-version: $(BUILD_DIR)/current_version
$(BUILD_DIR)/current_version: $(call depv,CURRENT_VERSION)
	echo $(CURRENT_VERSION) > $@

# Macroses for make
include $(SOURCE_DIR)/rules.mk

# Sandbox macroses.
include $(SOURCE_DIR)/sandbox.mk

# Modules
include $(SOURCE_DIR)/repos.mk
include $(SOURCE_DIR)/mirror/module.mk
include $(SOURCE_DIR)/packages/module.mk
include $(SOURCE_DIR)/iso/module.mk
