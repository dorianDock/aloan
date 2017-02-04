# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# cleaning everything
LoanTemplate.delete_all
Loan.delete_all
Borrower.delete_all

# Loan Templates

# 1 month, 500 000 MGA
LoanTemplate.create(amount: 500000, rate: 1, duration: 1, name: '1m500k')
# 4 months, 500 000 MGA
LoanTemplate.create(amount: 500000, rate: 5, duration: 4, name: '4m500k')



# 1 month, 1 M MGA
LoanTemplate.create(amount: 1000000, rate: 1, duration: 1, name: '1m1M', template_completed_before_id: LoanTemplate.find_by(name: '1m500k').id)
# 4 months, 1 M MGA
LoanTemplate.create(amount: 1000000, rate: 5, duration: 4, name: '4m1M', template_completed_before_id: LoanTemplate.find_by(name: '4m500k').id)


# 1 month, 2 M MGA
LoanTemplate.create(amount: 2000000, rate: 1, duration: 1, name: '1m2M', template_completed_before_id: LoanTemplate.find_by(name: '1m1M').id)
# 4 months, 2 M MGA
LoanTemplate.create(amount: 2000000, rate: 5, duration: 4, name: '4m2M', template_completed_before_id: LoanTemplate.find_by(name: '4m1M').id)


# 1 month, 5 M MGA
LoanTemplate.create(amount: 5000000, rate: 1, duration: 1, name: '1m5M', template_completed_before_id: LoanTemplate.find_by(name: '1m2M').id)
# 4 months, 5 M MGA
LoanTemplate.create(amount: 5000000, rate: 5, duration: 4, name: '4m5M', template_completed_before_id: LoanTemplate.find_by(name: '4m2M').id)


# 1 month, 10 M MGA
LoanTemplate.create(amount: 10000000, rate: 1, duration: 1, name: '1m10M', template_completed_before_id: LoanTemplate.find_by(name: '1m5M').id)
# 4 months, 10 M MGA
LoanTemplate.create(amount: 10000000, rate: 5, duration: 4, name: '4m10M', template_completed_before_id: LoanTemplate.find_by(name: '4m5M').id)


# Borrowers

Borrower.create(name: 'Msila msila', first_name: 'Niarabe', company_name: 'Ngara Corporation',
                birth_date: DateTime.new(1989,4,23), amount_wished: 40000,
                project_description: 'Il a besoin d une nouvelle machine a ecrire pour ecrire un top roman' )
Borrower.create(name: 'Banville', first_name: 'Guy', company_name: 'Norodo',
                birth_date: DateTime.new(1978,1,31), amount_wished: 20000,
                project_description: 'Un centre de coiffure en ville.')
Borrower.create(name: 'Bouille', first_name: 'Didier', company_name: 'Bouille et Fils',
                birth_date: DateTime.new(1965,4,24), amount_wished: 70000,
                project_description: 'Une entreprise de plomberie familiale.')
Borrower.create(name: 'Nabe', first_name: 'Celestin', company_name: 'Ifrap',
                birth_date: DateTime.new(1974,11,24), amount_wished: 10000,
                project_description: 'Un centre balneaire, une petite boutique dedans.')
Borrower.create(name: 'Sanada', first_name: 'France', company_name: 'Fruizuniques',
                birth_date: DateTime.new(1987,8,4), amount_wished: 50000,
                project_description: 'Boutique de fruits et legumes.')
Borrower.create(name: 'Kira', first_name: 'Aniki', company_name: 'Bazingages',
                birth_date: DateTime.new(1994,6,6), amount_wished: 40000,
                project_description: 'Vendre des bazingages.')
Borrower.create(name: 'Renald', first_name: 'Adrien', company_name: 'Imporfrance',
                birth_date: DateTime.new(1994,9,3), amount_wished: 80000,
                project_description: 'Importer des produits francais.')
Borrower.create(name: 'Fini', first_name: 'Henry', company_name: 'Henrys',
                birth_date: DateTime.new(1962,5,31), amount_wished: 90000,
                project_description: 'Consultant en affaires internationales, le budget lui permettrait de s installer a l etranger.')
Borrower.create(name: 'Nantier', first_name: 'Sebastien', company_name: 'Sebi',
                birth_date: DateTime.new(1993,8,11), amount_wished: 100000,
                project_description: 'Ameliorer son entreprise de joints de batiments en etat de decomposition.')
Borrower.create(name: 'Serfati', first_name: 'Arni', company_name: 'Serfan',
                birth_date: DateTime.new(1954,10,12), amount_wished: 60000,
                project_description: 'Faire des etudes de maison de retraite')
Borrower.create(name: 'Rana', first_name: 'Antisara', company_name: 'Ecole des etoiles',
                birth_date: DateTime.new(1978,1,31), amount_wished: 15000,
                project_description: 'Une ecole privee pour un avenir plein d etoiles.')



# Loans
# for 1st borrower
Loan.create(start_date: DateTime.new(2016,10,27), contractual_end_date: DateTime.new(2016,11,27), amount: 400000,
                rate: 2, loan_goal: 'Step of a bigger project, so the loan is just the beginning', borrower: Borrower.first)
Loan.create(start_date: DateTime.new(2016,11,28), contractual_end_date: DateTime.new(2016,12,28), amount: 800000,
            rate: 2, loan_goal: 'Step of a bigger project, so the loan is just the second in the story', borrower: Borrower.first, order: 2)
Loan.create(start_date: DateTime.new(2017,12,28), contractual_end_date: DateTime.new(2017,1,28), amount: 1600000,
            rate: 2, loan_goal: 'Step of a bigger project, so the loan is just the third in the story', borrower: Borrower.first, order: 3)
Loan.create(start_date: DateTime.new(2017,1,28), contractual_end_date: DateTime.new(2017,2,28), amount: 300000,
            rate: 2, loan_goal: 'Step of a bigger project, so the loan is just the fourth in the story', borrower: Borrower.first, order: 4)
Loan.create(start_date: DateTime.new(2017,2,28), contractual_end_date: DateTime.new(2017,3,28), amount: 600000,
            rate: 2, loan_goal: 'Step of a bigger project, so the loan is just the fourth in the story', borrower: Borrower.first, order: 5)
Loan.create(start_date: DateTime.new(2017,3,28), contractual_end_date: DateTime.new(2017,4,28), amount: 1000000,
            rate: 2, loan_goal: 'Step of a bigger project, so the loan is just the fourth in the story', borrower: Borrower.first, order: 6)

# for 2nd borrower
second_borrower = Borrower.find_by(name: 'Banville')
Loan.create(start_date: DateTime.new(2016,11,10), contractual_end_date: DateTime.new(2017,1,10), amount: 400000,
            rate: 2, loan_goal: 'He needs to get higher loans quickly', borrower: second_borrower, order: 1)
Loan.create(start_date: DateTime.new(2017,1,10), contractual_end_date: DateTime.new(2017,3,10), amount: 800000,
            rate: 2, loan_goal: 'He needs to get higher loans quickly', borrower: second_borrower, order: 2)
Loan.create(start_date: DateTime.new(2017,3,10), contractual_end_date: DateTime.new(2017,5,10), amount: 1000000,
            rate: 2, loan_goal: 'He needs to get higher loans quickly', borrower: second_borrower, order: 3)
Loan.create(start_date: DateTime.new(2017,5,10), contractual_end_date: DateTime.new(2017,7,10), amount: 1500000,
            rate: 2, loan_goal: 'He needs to get higher loans quickly', borrower: second_borrower, order: 4)

# for third borrower
third_borrower = Borrower.find_by(name: 'Nabe')
Loan.create(start_date: DateTime.new(2016,9,10), contractual_end_date: DateTime.new(2016,10,10), amount: 200000,
            rate: 2, loan_goal: 'He needs s stable loan provider', borrower: third_borrower, order: 1)
Loan.create(start_date: DateTime.new(2016,10,10), contractual_end_date: DateTime.new(2016,11,10), amount: 400000,
            rate: 2, loan_goal: 'He needs s stable loan provider', borrower: third_borrower, order: 2)
Loan.create(start_date: DateTime.new(2016,11,10), contractual_end_date: DateTime.new(2016,12,10), amount: 600000,
            rate: 2, loan_goal: 'He needs s stable loan provider', borrower: third_borrower, order: 3)
Loan.create(start_date: DateTime.new(2016,12,10), contractual_end_date: DateTime.new(2017,1,10), amount: 800000,
            rate: 2, loan_goal: 'He needs s stable loan provider', borrower: third_borrower, order: 4)
Loan.create(start_date: DateTime.new(2017,1,10), contractual_end_date: DateTime.new(2017,2,10), amount: 800000,
            rate: 2, loan_goal: 'He needs s stable loan provider', borrower: third_borrower, order: 5)

# for fourth borrower
fourth_borrower = Borrower.find_by(name: 'Sanada')
Loan.create(start_date: DateTime.new(2016,10,2), contractual_end_date: DateTime.new(2017,2,2), amount: 400000,
            rate: 2, loan_goal: 'A small loan to try, the rest to thrive', borrower: fourth_borrower, order: 1)
Loan.create(start_date: DateTime.new(2017,2,2), contractual_end_date: DateTime.new(2017,4,2), amount: 800000,
            rate: 2, loan_goal: 'A small loan to try, the rest to thrive', borrower: fourth_borrower, order: 2)
Loan.create(start_date: DateTime.new(2017,4,2), contractual_end_date: DateTime.new(2017,6,2), amount: 200000,
            rate: 2, loan_goal: 'A small loan to try, the rest to thrive', borrower: fourth_borrower, order: 3)

# for fifth borrower
fifth_borrower = Borrower.find_by(name: 'Kira')
Loan.create(start_date: DateTime.new(2016,10,15), contractual_end_date: DateTime.new(2016,11,15), amount: 600000,
            rate: 2, loan_goal: 'A big loan to try, the rest to thrive', borrower: fifth_borrower, order: 1)
Loan.create(start_date: DateTime.new(2016,11,15), contractual_end_date: DateTime.new(2016,12,15), amount: 800000,
            rate: 2, loan_goal: 'A big loan to try, the rest to thrive', borrower: fifth_borrower, order: 2)
Loan.create(start_date: DateTime.new(2017,1,15), contractual_end_date: DateTime.new(2017,2,15), amount: 1000000,
            rate: 2, loan_goal: 'A big loan to try, the rest to thrive', borrower: fifth_borrower, order: 3)



# for last borrower
sixth_borrower = Borrower.find_by(name: 'Reynald')
Loan.create(start_date: DateTime.new(2016,8,4), contractual_end_date: DateTime.new(2016,9,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 1)
Loan.create(start_date: DateTime.new(2016,9,4), contractual_end_date: DateTime.new(2016,10,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 2)
Loan.create(start_date: DateTime.new(2016,10,4), contractual_end_date: DateTime.new(2016,11,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 3)
Loan.create(start_date: DateTime.new(2016,11,4), contractual_end_date: DateTime.new(2016,12,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 4)
Loan.create(start_date: DateTime.new(2016,12,4), contractual_end_date: DateTime.new(2017,1,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 5)
Loan.create(start_date: DateTime.new(2017,1,4), contractual_end_date: DateTime.new(2017,2,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 6)
Loan.create(start_date: DateTime.new(2017,2,4), contractual_end_date: DateTime.new(2017,3,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 7)
Loan.create(start_date: DateTime.new(2017,3,4), contractual_end_date: DateTime.new(2017,4,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 8)
Loan.create(start_date: DateTime.new(2017,4,4), contractual_end_date: DateTime.new(2017,5,4), amount: 600000,
            rate: 2, loan_goal: 'Medium loan to make the business work', borrower: sixth_borrower, order: 9)


