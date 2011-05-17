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

end

