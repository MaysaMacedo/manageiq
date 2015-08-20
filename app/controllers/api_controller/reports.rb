class ApiController
  module Reports
    #
    # Reports Supporting Methods
    #
    def results_query_resource(object)
      object.send("miq_report_results")
    end

    def show_reports
      if @req[:subcollection] == "results" && (@req[:s_id] || expand?(:resources)) && attribute_selection == "all"
        @req[:additional_attributes] = %w(result_set)
      end
      show_generic(:reports)
    end

    def run_resource_reports(_type, id, _data)
      report = MiqReport.find(id)
      report.queue_generate_table do |task, report_result|
        return run_report_result(true, "running report #{report.id}", :task_id => task.id, :report_result_id => report_result.id)
      end
    rescue => err
      run_report_result(false, err.to_s)
    end

    def run_report_result(success, message = nil, options = {})
      res = {:success => success}
      res[:message] = message if message.present?
      add_parent_href_to_result(res)
      add_report_result_to_result(res, options[:report_result_id]) if options[:report_result_id].present?
      add_task_to_result(res, options[:task_id]) if options[:task_id].present?
      res
    end

    def add_report_result_to_result(hash, result_id)
      hash[:result_id] = result_id
      hash[:result_href] = "#{@req[:base]}#{@req[:prefix]}/results/#{result_id}"
      hash
    end
  end
end
