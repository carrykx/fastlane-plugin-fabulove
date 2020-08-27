require 'fastlane/action'
require_relative '../helper/fabulove_helper'
require 'httparty'

module Fastlane
  module Actions
    class FabuloveAction < Action
      def self.run(params)
        UI.message("The fabulove plugin is working!")
        
        base_url = params[:base_url]
        team_id = params[:team_id]
        file_path = params[:file_path]
        username = params[:username]
        password = params[:password]
        keep_num = params[:keep_app_versions_num]

        token = self.get_token(base_url, username, password)
        # UI.message "token:#{token}"

        app_id = self.upload_page(base_url, token, team_id, file_path)

        if app_id && keep_num > 0
          # 如果上传成功，则进行删除一个老的版本
          self.delete_old_version(base_url, token, app_id, keep_num, team_id)
        end
        
        UI.message "The fabulove action is end!"
      end

      def self.get_token (base_url, username, password)
        response = HTTParty.post("#{base_url}/api/user/login",{
          :body => {"username" => username, "password" => password}.to_json,
          :headers => {'Content-Type'=>'application/json'}
        })

        body = JSON.parse(response.body)

        if body['success'] == true
          UI.message "get token success"          
        end
        
        return body['data']['token']
      end

      def self.upload_page (base_url, token, team_id, file_path)
        authorization = "Bearer #{token}"
        response = HTTParty.post("#{base_url}/api/apps/#{team_id}/upload",{
          :headers => {'accept'=>'application/json', 'Authorization'=>authorization, 'Content-Type'=>'multipart/form-data'},
          :body => {file:File.open(file_path)}
        })

        # puts response.body

        body = JSON.parse(response.body)

        if body['success'] == false
          UI.message "upload failed，error message：#{body['message']}"
          return nil
        end
        UI.message "upload file success"
        return body['data']['app']['_id']
      end

      def self.delete_old_version (base_url, token, app_id, keep_num, team_id)
        authorization = "Bearer #{token}"
        get_response = HTTParty.get("#{base_url}/api/apps/#{team_id}/#{app_id}/versions?page=0&size=#{keep_num*2}",{
          :headers => {'Content-Type'=>'application/json', 'Authorization'=>authorization}
        })

        # puts get_response.body

        versions_body = JSON.parse(get_response.body)

        if versions_body['success'] == false
          UI.message "get app versions failed"
          return
        end

        UI.message "get app versions success"

        if versions_body['data'].size <= keep_num
          UI.message "existing version <= keep_num"
          return
        end
        
        # 进行删除操作
        app_version_info = versions_body['data'].first
        app_version_id = app_version_info['_id']

        delete_response = HTTParty.delete("#{base_url}/api/apps/#{team_id}/#{app_id}/versions/#{app_version_id}",{
          :headers => {'Content-Type'=>'application/json', 'Authorization'=>authorization}
        })

        # puts delete_response.body

        delete_version_body = JSON.parse(delete_response.body)

        if delete_version_body['success'] == true
          UI.message "delete version success"
        else
          UI.message "delete version failed"
        end

      end

      def self.description
        "'fabulove' distribution system fastlane plugin"
      end

      def self.authors
        ["carry"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "'fabulove' distribution system fastlane plugin"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "FL_FABULOVE_USERNAME", # The name of the environment variable
                                       description: "You fabulove username", # a short description of this parameter
                                       is_string: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: "FL_FABULOVE_PASSWORD",
                                       description: "You fabulove password",
                                       is_string: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :base_url,
                                       env_name: "FL_FABULOVE_BASE_URL", # The name of the environment variable
                                       description: "You custom fabulove server url address.Example:https://gitlab.engineerhope.com:444", # a short description of this parameter
                                       is_string: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :team_id,
                                       env_name: "FL_FABULOVE_TEAM_ID",
                                       description: "You fabulove team_id",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       default_value: nil), # the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :file_path,
                                       env_name: "FL_FABULOVE_FILE_PATH",
                                       description: "FILE APP PATH",
                                       default_value: nil,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :keep_app_versions_num,
                                       env_name: "FL_FABULOVE_KEEP_NUM",
                                       description: "Keep app versions number",
                                       is_string: false,
                                       default_value: nil,
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
