module PPC
  class Baidu
    class ReportException < Exception
      attr_reader :file_id,:report,:exception
      def initialize(file_id,report,exception)
        @file_id    = file_id
        @report     = report
        @exception  = exception
      end
    end

    class Report < ::PPC::Baidu
      def initialize(params = {})
        params[:service] = 'Report'
        super
      end

      def file_id_of_query(params = {})
        begin
          startDate = DateTime.parse(params[:start]).iso8601
          endDate = DateTime.parse(params[:end]).iso8601
        rescue Exception => e
          startDate = (Time.now - 2*24*3600).utc.iso8601
          endDate = (Time.now - 24*3600).utc.iso8601
        end
        options = {
          reportRequestType: {
            performanceData:        params[:fields] || %w(click impression),
            startDate:              startDate,
            endDate:                endDate,
            idOnly:                 params[:id_only]|| false,
            levelOfDetails:         params[:level]  || 12,
            format:                 params[:format] || 2,
            reportType:             params[:type]   || 6,
            statRange:              params[:range]  || 2,
            unitOfTime:             params[:unit]   || 5,
            device:                 params[:device] || 0
          }
        }
        get_report_id(options)
      end

      def file_id_of_cost(params={})
        begin
          startDate = DateTime.parse(params[:start]).iso8601
          endDate = DateTime.parse(params[:end]).iso8601
        rescue Exception => e
          startDate = (Time.now - 2*24*3600).utc.iso8601
          endDate = (Time.now - 24*3600).utc.iso8601
        end
        options = {
          reportRequestType: {
            performanceData:        params[:fields] || %w(impression click cpc cost ctr cpm position conversion),
            startDate:              startDate,
            endDate:                endDate,
            levelOfDetails:         params[:level]  || 11, #::Baidu::SEM::LevelOfDetails::KEYWORDID,
            reportType:             params[:type]   || 14, #::Baidu::SEM::ReportType::KEYWORDID,
            statRange:              params[:range]  || 11, # ::Baidu::SEM::StatRange::KEYWORDID,
            unitOfTime:             params[:unit]   || 5 #::Baidu::SEM::UnitOfTime::DAY
          }
        }
        get_report_id(options)
      end

      def get_report_id(options={})
        response = request('getProfessionalReportId',options)
        body = response[:envelope][:body]
        raise "no result" if body.nil?
        body[:get_professional_report_id_response][:report_id]
      end

      def state(id)
        raise "empty id" if id.nil? or id.empty?
        request('getReportState',{reportId:id})[:envelope][:body][:get_report_state_response][:is_generated]
      end

      def path(id)
        request('getReportFileUrl',{reportId:id})[:envelope][:body][:get_report_file_url_response][:report_file_path]
      end
    end
  end
end
