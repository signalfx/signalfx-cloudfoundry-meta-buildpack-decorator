BUILDPACK_NAME := signalfx_decorator
INCLUDED_FILES := bin/* collectd.tar.gz run-collectd.sh

$(BUILDPACK_NAME).zip: $(INCLUDED_FILES)
	rm -f $(BUILDPACK_NAME).zip
	zip -r $(BUILDPACK_NAME).zip $(INCLUDED_FILES)

push-to-cf: $(BUILDPACK_NAME).zip
	cf delete-buildpack -f $(BUILDPACK_NAME)
	cf create-buildpack $(BUILDPACK_NAME) $(BUILDPACK_NAME).zip 99 --enable
