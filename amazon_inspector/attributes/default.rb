# Use attribute precedence to tweak whether or not to install Amazon Inspector agent in a particular node
default['amazon_inspector']['gpgkey_url']        = 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/inspector.gpg'
default['amazon_inspector']['gpg_signature_url'] = 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install.sig'
default['amazon_inspector']['installer_url']     = 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install'
