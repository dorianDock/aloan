# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Borrowers
Borrower.delete_all
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



