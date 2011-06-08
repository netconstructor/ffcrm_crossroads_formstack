require "fat_free_crm"

FatFreeCRM::Plugin.register(:crm_crossroads_formstack, self) do
          name "Crossroads Formstack"
        author "Nathan Broadbent"
       version "1.0"
   description "Integrate Crossroads Formstack volunteer forms with FFCRM"
  dependencies :crm_crossroads, :crm_super_tags
end

