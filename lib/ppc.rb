require 'ppc/baidu'
module PPC
  VERSION = "1.0.7"
  attr_reader :header,:body,:rquota,:quota,:status,:desc,:oprs,:oprtime,:code,:message
  attr_accessor :username,:password,:token,:debug
  def initialize(params = {})
    @service    = params[:service]
    @username   = params[:username]
    @password   = params[:password]
    @token      = params[:token]
    @debug      = params[:debug] || false
  end

  protected
  def print_debug(var,varname=nil)
    puts '=' * 10 + varname.to_s + '=' * 10
    if var.is_a? String
      puts var
    else
      ap var
    end
    puts '=' * 10 + varname.to_s + '=' * 10
  end
end
