class AddCrossroadsCustomFields < ActiveRecord::Migration
  
  def add_column_unless_exists(column_name, type)
    add_column(:contacts, column_name, type) unless column_exists?(:contacts, column_name)
  end

  def change
    add_column_unless_exists "cf_chinese_name", :string
    add_column_unless_exists "cf_preferred_name", :string
    add_column_unless_exists "cf_salutation", :string
    add_column_unless_exists "cf_octopus", :string
    add_column_unless_exists "cf_email_subscriptions", :string
    add_column_unless_exists "cf_how_did_you_hear_about_crossroads", :text
    add_column_unless_exists "cf_availability", :text
    add_column_unless_exists "cf_interested_in_doing", :text
    add_column_unless_exists "cf_age", :string
    add_column_unless_exists "cf_why_would_you_like_to_volunteer", :text
    add_column_unless_exists "cf_other_information", :text
    add_column_unless_exists "cf_volunteering_type", :text
    add_column_unless_exists "cf_school_or_company", :text
    add_column_unless_exists "cf_skills", :text
    add_column_unless_exists "cf_languages_spoken", :text
    add_column_unless_exists "cf_tour_date", :date
    add_column_unless_exists "cf_service_certificates", :text
    add_column_unless_exists "cf_seventy_hour_service_certificate", :date
    add_column_unless_exists "cf_one_hundred_forty_hour_service_certificate", :date
    add_column_unless_exists "cf_resume", :string
    add_column_unless_exists "cf_interests", :text
    add_column_unless_exists "cf_three_month_review", :date
    add_column_unless_exists "cf_trial_period_review", :date
    add_column_unless_exists "cf_left_the_training_program", :boolean
    add_column_unless_exists "cf_trainee_status", :string
    add_column_unless_exists "cf_trainee_contract_signed", :boolean
    add_column_unless_exists "cf_volunteer_status", :string
  end
end
