require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include SampleFormstackSubmissions


describe VolunteersFormstack do

  it "should be able to extract and process the information from a submission" do
    [sample_volunteer_submission,
     sample_volunteer_traditional_submission,
     sample_volunteer_simplified_submission,
     sample_volunteer_internship_submission].each do |submission_hash|
        result = VolunteersFormstack.submission_to_hash(submission_hash[:submission],
                                                        submission_hash[:form_id])
        result.should == submission_hash[:result]
    end
  end

  it "should raise an error if key fields are blank" do
    data = {"formstack_email" => {"contact" => {}, "formstack_submission" => {}}}
    lambda {
      VolunteersFormstack.process_formstack_submission(data)
    }.should raise_error(FormstackFieldError, "Field is blank: Availability")
  end

  it "should raise an error if an unhandled field is added to the form" do
    data = {"data" => [Hashie::Mash.new(:field => "1234567", :value => "I'm a new field!")]}
    lambda {
      VolunteersFormstack.validate_no_new_fields(data, 1030950)
    }.should raise_error(FormstackFieldError, "The following fields have been added to form 1030950 :: [1234567: I'm a new field!]")
  end

end

