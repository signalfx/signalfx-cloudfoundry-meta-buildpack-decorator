BUILDPACK_NAME := signalfx_decorator
BUNDLE_VERSION := $(shell cat VERSION | sed 's/\(-.\)\..*$$/\1/')
INCLUDED_FILES := bin/* collectd-bundle-$(BUNDLE_VERSION).tar.gz run-collectd.sh

collectd-bundle-$(BUNDLE_VERSION).tar.gz:
	wget https://github.com/signalfx/collectd-build-bundle/releases/download/v$(BUNDLE_VERSION)/collectd-bundle-$(BUNDLE_VERSION).tar.gz

$(BUILDPACK_NAME).zip: $(INCLUDED_FILES)
	rm -f $(BUILDPACK_NAME).zip
	zip -r $(BUILDPACK_NAME).zip $(INCLUDED_FILES) VERSION

push-to-cf: $(BUILDPACK_NAME).zip
	cf delete-buildpack -f $(BUILDPACK_NAME)
	cf create-buildpack $(BUILDPACK_NAME) $(BUILDPACK_NAME).zip 99 --enable

.PHONY: push-to-cf
