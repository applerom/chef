# Use attribute precedence to tweak whether or not to install Amazon Inspector agent in a particular node
default[:inspector][:enabled]           = true
default[:inspector][:gpgkey_url]        = 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/inspector.gpg'
default[:inspector][:gpg_signature_url] = 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install.sig'
default[:inspector][:installer_url]     = 'https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install'
