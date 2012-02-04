# encoding: utf-8

module SampleFormstackSubmissions
  def sample_volunteer_submission
    {:form_id => 1030950,
     :submission => {
        "id"      =>"49036984",
        "10474085"=>"Mr",
        "10474086"=>"Tester Test",
        "10474087"=>"麥道昕",
        "10474088"=>"Nathan",
        "10474090"=>"I am currently a student",
        "10474091"=>"Christian Alliance P.C. Lau Memorial International School",
        "10474093"=>"Other: I am volunteering with my friends",
        "10474096"=>"etsetsedge@example.com",
        "10474097"=>"Email me about events, opportunities etc.",
        "10474098"=>"21412353",
        "10474099"=>"",
        "10474100"=>"Hong Kong",
        "10474178"=>"Flat a, bcd, efg",
        "10474180"=>"23432 STREET, Kowloon Tong, Hong Kong",
        "10474101"=>"Kowloon",
        "10474105"=>"Familiar with Windows OS, Microsoft Word, Microsoft Powerpoint, and Microsoft Excel.\r\nExperienced with GIMP.\r\nVolunteered at school's Primary Sport's Day twice.",
        "10474107"=>"Basketball.\r\nWatching movies.\r\nVideo games.\r\nPiano.",
        "10474108"=>"English = Fluent\nCantonese = Basic\nMandarin = Basic\nFrench = None",
        "10474110"=>"To give back to the community.\r\nTo gain experience with volunteering outside of school.\r\nTo make people happy and enjoy life.",
        "10474111"=>"friend",
        "10474114"=>"programme",
        "10474115"=>"silver certificate",
        "10474117"=>"Tuesday = Whole day\nWednesday = Not available\nThursday = Whole day\nFriday = Not available\nSaturday = Whole day",
        "10474119"=>"Happy to try anything*",
        "10474120"=>"Typing*\nPhotocopying, binding etc*\nMailroom*",
        "10474121"=>"Cooking*\nCleaning*",
        "10474122"=>"Lifting / carrying\nPacking help",
        "10474123"=>"Renovation work\nGardening*",
        "13538104"=>"30+"
      },
    :result => {
       "formstack_email"=> {
         "contact"=> {
           "name"=>"Tester Test",
           "email"=>"etsetsedge@example.com",
           "phone"=>"21412353",
           "mobile"=>"",
           "address"=> {
              "country"=>"Hong Kong",
              "zipcode"=>"",
              "state"=>"Kowloon",
              "street1"=>"Flat a, bcd, efg",
              "street2"=>"23432 STREET, Kowloon Tong, Hong Kong",
              "city"=>""
            }
          },
        "formstack_submission"=> {
          "salutation"=>"Mr",
          "preferred_name"=>"Nathan",
          "chinese_name"=>"麥道昕",
          "skills"=>"Familiar with Windows OS, Microsoft Word, Microsoft Powerpoint, and Microsoft Excel.\r\nExperienced with GIMP.\r\nVolunteered at school's Primary Sport's Day twice.",
          "resume"=>"",
          "interests"=>"Basketball.\r\nWatching movies.\r\nVideo games.\r\nPiano.",
          "languages_spoken"=>"English = Fluent\nCantonese = Basic\nMandarin = Basic\nFrench = None",
          "availability"=>"Tuesday = Whole day\nWednesday = Not available\nThursday = Whole day\nFriday = Not available\nSaturday = Whole day",
          "receive_emails"=>"Email me about events, opportunities etc.",
          "why_would_you_like_to_volunteer"=>"To give back to the community.\r\nTo gain experience with volunteering outside of school.\r\nTo make people happy and enjoy life.",
          "how_did_you_hear_about_crossroads"=>"friend",
          "interested_in_doing"=>"Happy to try anything*\nTyping*\nPhotocopying, binding etc*\nMailroom*\nCooking*\nCleaning*\nLifting / carrying\nPacking help\nRenovation work\nGardening*\n",
          "school_or_company"=>"Are you a student?:  I am currently a student\nSchool, university, etc.:  Christian Alliance P.C. Lau Memorial International School\nCompany:  ",
          "volunteering_type"=>"Special Programme:  silver certificate\nTime commitment:  programme\nVolunteering with group?:  Other: I am volunteering with my friends",
          "other_information"=>"",
          "age"=>"30+"
        }
      }
    }}
  end

  def sample_volunteer_traditional_submission
   {:form_id => 1049958,
    :submission => {
      "id"      =>"49037266",
      "10893134"=>"Mr",
      "10893135"=>"TEST TEST",
      "10893136"=>"TEST",
      "10893137"=>"人參與志願",
      "10893139"=>"I am currently employed",
      "10893141"=>"僱用企業名稱",
      "10893142"=>"with my school",
      "10893144"=>"test@example.com",
      "10893145"=>"Email me about events, opportunities etc.",
      "10893146"=>"12431242",
      "10893147"=>"12521363",
      "10893148"=>"香港",
      "10893149"=>"asdfasdfasdf",
      "10893150"=>"asdfasdfasdf",
      "10893153"=>"NT",
      "10893157"=>"專業/曾就讀的科目/其它技",
      "10893159"=>"意看到你的個人履",
      "10893160"=>"英語 = 不會說\n廣東話 = 初等水平\n普通話 = 熟練水平\n法語 = 熟練水平",
      "10893162"=>"會來幫忙",
      "10893163"=>"internet",
      "10893166"=>"occasionally",
      "10893169"=>"星期二 = 全天\n星期三 = 全天\n星期四 = 上午\n星期五 = 上午\n星期六 = 下午",
      "10893171"=>"Happy to try anything*",
      "10893172"=>"Reception\nAccounting\nOnline research\nGrant writing\nHardware care/renovation"
    },
    :result => {
      "formstack_email"=> {
         "contact"=> {
           "name"=>"TEST TEST",
           "email"=>"test@example.com",
           "phone"=>"12431242",
           "mobile"=>"12521363",
           "address"=> {
             "country"=>"Hong Kong",
             "zipcode"=>"",
             "state"=>"NT",
             "street1"=>"asdfasdfasdf",
             "street2"=>"asdfasdfasdf",
             "city"=>""
           }
         },
        "formstack_submission"=> {
          "salutation"=>"Mr",
          "preferred_name"=>"人參與志願",
          "chinese_name"=>"TEST",
          "skills"=>"專業/曾就讀的科目/其它技",
          "resume"=>"",
          "interests"=>"意看到你的個人履",
          "languages_spoken"=>"English = None\nCantonese = Basic\nMandarin = Fluent\nFrench = Fluent",
          "availability"=>"tuesday = whole day\nwednesday = whole day\nthursday = morning\nfriday = morning\nsaturday = afternoon",
          "receive_emails"=>"Email me about events, opportunities etc.",
          "why_would_you_like_to_volunteer"=>"會來幫忙",
          "how_did_you_hear_about_crossroads"=>"internet",
          "interested_in_doing"=>"Happy to try anything*\nReception\nAccounting\nOnline research\nGrant writing\nHardware care/renovation\n\n\n\n",
          "school_or_company"=>"Are you a student?:  I am currently employed\nSchool, university, etc.:  \nCompany:  僱用企業名稱",
          "volunteering_type"=>"Special Programme:  \nTime commitment:  occasionally\nVolunteering with group?:  with my school",
          "other_information"=>"",
          "age"=>""
        }
      }
    }}
  end

  def sample_volunteer_simplified_submission
   {:form_id => 1049957,
    :submission => {
      "id"=>"49147323",
      "10893089"=>"Mr",
      "10893090"=>"asdgasdg asdgasdg",
      "10893091"=>"asdg",
      "10893092"=>"asdg",
      "10893094"=>"I am currently employed",
      "10893096"=>"sadgasdgsdag",
      "10893097"=>"with my company",
      "10893099"=>"sdgasdga@gasdg.com",
      "10893100"=>"Email me about events, opportunities etc.",
      "10893101"=>"23523632",
      "10893102"=>"23623363",
      "10893103"=>"其它",
      "10893104"=>"1 st st",
      "10893105"=>"gold place",
      "10893106"=>"hoola hoop",
      "10893107"=>"woohoohoo",
      "10893109"=>"1234",
      "10893110"=>"Bangladesh",
      "10893112"=>"dfshsdfaadrhdfahdafh",
      "10893114"=>"adfhadfhadfhdafh",
      "10893115"=>"英语 = 初等水平\n广东话 = 熟练水平\n普通话 = 初等水平\n法语 = 熟练水平",
      "10893117"=>"sadghasdhdafhadfh",
      "10893118"=>"internet\nfriend",
      "10893121"=>"occasionally",
      "10893124"=>"星期二 = 不适合\n星期三 = 全天\n星期四 = 上午\n星期五 = 下午\n星期六 = 上午",
      "10893126"=>"Happy to try anything*\nHappy to try anything, but no heavy lifting*",
      "10893127"=>"Photocopying, binding etc*",
      "10893129"=>"Truck driving",
      "10893131"=>"Optometrist"},
    :result => {
      "formstack_email"=>{
        "contact"=>{
          "name"=>"asdgasdg asdgasdg",
          "email"=>"sdgasdga@gasdg.com",
          "phone"=>"23523632",
          "mobile"=>"23623363",
          "address"=>{
            "country"=>"Bangladesh",
            "zipcode"=>"1234",
            "state"=>"woohoohoo",
            "street1"=>"1 st st",
            "street2"=>"gold place",
            "city"=>"hoola hoop"
          }
        },
      "formstack_submission"=>{
        "salutation"=>"Mr",
        "preferred_name"=>"asdg",
        "chinese_name"=>"asdg",
        "skills"=>"dfshsdfaadrhdfahdafh",
        "resume"=>"",
        "interests"=>"adfhadfhadfhdafh",
        "receive_emails"=>"Email me about events, opportunities etc.",
        "why_would_you_like_to_volunteer"=>"sadghasdhdafhadfh",
        "how_did_you_hear_about_crossroads"=>"internet\nfriend",
        "languages_spoken"=>"English = Basic\nCantonese = Fluent\nMandarin = Basic\nFrench = Fluent",
        "availability"=>"tuesday = not available\nwednesday = whole day\nthursday = morning\nfriday = afternoon\nsaturday = morning",
        "interested_in_doing"=>"Happy to try anything*\nHappy to try anything, but no heavy lifting*\nPhotocopying, binding etc*\n\nTruck driving\n\nOptometrist",
        "school_or_company"=>"Are you a student?:  I am currently employed\nSchool, university, etc.:  \nCompany:  sadgasdgsdag",
        "volunteering_type"=>"Special Programme:  \nTime commitment:  occasionally\nVolunteering with group?:  with my company",
        "other_information"=>"",
        "age"=>""
      }
    }}}
  end

  def sample_volunteer_internship_submission
   {:form_id => 1064470,
    :submission => {
      "id"=>"49147121",
      "11251914"=>"Mr",
      "11251915"=>"hgnhsdfh sdfhdsfh",
      "11251916"=>"dfhds",
      "11251917"=>"fdshdsfh",
      "11251920"=>"asdgdsgag",
      "11251924"=>"asdgasdg@gmail.com",
      "11251925"=>"Email me about events, opportunities etc.",
      "11251926"=>"23523",
      "11251927"=>"523523",
      "11251929"=>"23532",
      "11251930"=>"32523523",
      "11251933"=>"Central",
      "11251937"=>"asdgadsgsad",
      "11251938"=>"http://files.formstack.com/uploads/1064470/4dd1f4f0028f3/letterofsupport.PDF",
      "11251939"=>"sdagsdgasdg",
      "11251940"=>"English = Fluent\nCantonese = Basic\nMandarin = Basic\nFrench = Basic",
      "11251942"=>"sdagasdgsdagsdgasdgsdag",
      "11251943"=>"internet\nfriend\ngroup",
      "11252032"=>"12 July - 20 August, 2011 (Second Intake)",
      "11251952"=>"Reception\nTyping\nBook-keeping\nTranslation\nHardware care/renovation\nWeb design",
      "11252090"=>"DIET REQUIREMENT"
    },
    :result => {
      "formstack_email"=>{
        "contact"=>{
          "name"=>"hgnhsdfh sdfhdsfh",
          "email"=>"asdgasdg@gmail.com",
          "phone"=>"23523",
          "mobile"=>"523523",
          "address"=>{
            "country"=>"Hong Kong",
            "zipcode"=>"",
            "state"=>"Central",
            "street1"=>"23532",
            "street2"=>"32523523",
            "city"=>""
          }
        },
      "formstack_submission"=>{
        "salutation"=>"Mr",
        "preferred_name"=>"fdshdsfh",
        "chinese_name"=>"dfhds",
        "skills"=>"asdgadsgsad",
        "resume"=>"http://files.formstack.com/uploads/1064470/4dd1f4f0028f3/letterofsupport.PDF",
        "interests"=>"sdagsdgasdg",
        "receive_emails"=>"Email me about events, opportunities etc.",
        "why_would_you_like_to_volunteer"=>"sdagasdgsdagsdgasdgsdag",
        "how_did_you_hear_about_crossroads"=>"internet\nfriend\ngroup",
        "languages_spoken"=>"English = Fluent\nCantonese = Basic\nMandarin = Basic\nFrench = Basic",
        "availability"=>"", "interested_in_doing"=>"\nReception\nTyping\nBook-keeping\nTranslation\nHardware care/renovation\nWeb design\n\n\n\n",
        "school_or_company"=>"School:  asdgdsgag",
        "volunteering_type"=>"Internship",
        "other_information"=>"Internship Period:  12 July - 20 August, 2011 (Second Intake)\nDietary requirements or physical conditions:  DIET REQUIREMENT",
        "age"=>""
      }}
    }}
  end
end
