class UniqAppValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.job.applications.pluck(:applicant_id).include?(value)
      record.errors[attribute] << (options[:message] || "You can only apply once for a job, edit your application if you want to make some changes")
    end
  end
end