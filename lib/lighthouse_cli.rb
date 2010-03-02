require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'lighthouse-api', 'lib', 'lighthouse-api'))

require 'yaml'
require 'hirb'
require 'lighthouse_cli/config'
require 'lighthouse_cli/authenticator'
require 'lighthouse_cli/helpers'
require 'lighthouse_cli/commands'
require 'lighthouse_cli/parser'

module LighthouseCLI
  if (File.exists?("Lhcfile"))
    DEFAULT_CONFIG_PATH = "Lhcfile"
  else
    DEFAULT_CONFIG_PATH = File.join(ENV['HOME'], ".lighthouse_cli", "Lhcfile")
  end

  def bootstrap!
    Authenticator.authenticate!
    ::Lighthouse.account = Config.account
  end

  def project
    project_name = Config.project

    @project ||= if project_name
      ::Lighthouse::Project.find(:all).find{|p| p.name == Config.project}
    else
      nil
    end

    @project || (raise RuntimeError.new("Project not found or wasn't configured."))
  end

  module_function :bootstrap!, :project
end