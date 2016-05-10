class Log < ActiveRecord::Base

    serialize :content, Hash

end
