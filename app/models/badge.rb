class Badge < ActiveRecord::Base
  mount_uploader :bgraphic, BgraphicUploader
end
