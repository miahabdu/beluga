CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAIN4C2JKL7SMMH3EA',                        # required
    :aws_secret_access_key  => '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',                        # required
  }
  config.fog_directory  = 'gastrochub'                     # required
end