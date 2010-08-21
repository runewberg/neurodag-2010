class Faqs
  belongs_to  :user
  key :schools, Text
  key :companies, Text
  key :books_written, Text
  key :short_cv, Text
  key :selected_papers, Text
  key :work_experience, Text
  key :job_advertisement, Text
  timestamps!
end
