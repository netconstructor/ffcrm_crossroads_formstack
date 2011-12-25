# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include SampleFormstackSubmissions


describe VolunteersFormstack do

  def expand_hash(hash)
    field_array = hash[:submission].map do |field, value|
      Hashie::Mash.new(:field => field, :value => value) unless field == "id"
    end.compact
    # This formstack_hash is an approximation of the data that is returned
    # by the Formstack Ruby API. This is all written terribly, and I apologize.
    hash[:submission].merge({"data" => field_array})
  end

  it "should be able to extract and process the information from a submission" do
    # Apologies for the following code.
    # It is a terrible, terrible hack, and should be burnt.
    # Seriously, this all needs to be rewritten.
    [sample_volunteer_submission,
     sample_volunteer_traditional_submission,
     sample_volunteer_simplified_submission,
     sample_volunteer_internship_submission].each do |submission_hash|
        result = VolunteersFormstack.submission_to_hash(expand_hash(submission_hash),
                                                        submission_hash[:form_id])
        result.should == submission_hash[:result]
    end
  end

  it "should raise an error if key fields are blank" do
    data = {"formstack_email" => {"contact" => {}, "formstack_submission" => {}}}
    lambda {
      VolunteersFormstack.process_formstack_submission(data, 1030950)
    }.should raise_error(FormstackFieldError, "Field is blank: Availability")
  end

  it "should raise an error if an unhandled field is added to the form" do
    data = {"data" => [Hashie::Mash.new(:field => "1234567", :value => "I'm a new field!")]}
    lambda {
      VolunteersFormstack.validate_no_new_fields(data, 1030950)
    }.should raise_error(FormstackFieldError, "The following fields have been added to form 1030950 :: [1234567: I'm a new field!]")
  end


  it "should process a submission successfully" do
    VolunteersFormstack.process_formstack_submission(sample_volunteer_submission[:result], 1030950)
    c = Contact.find_by_email("etsetsedge@example.com")
    c.cf_how_did_you_hear_about_crossroads.should == "friend"
    c.cf_chinese_name.should == "麥道昕"
    c.cf_age.should == "30+"
    c.phone.should == "21412353"
  end
end

