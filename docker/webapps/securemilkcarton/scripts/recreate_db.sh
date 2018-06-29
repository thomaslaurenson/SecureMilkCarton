echo ">>> Starting recreation of database for secure milk..."

echo ">>> Deleting current database..."

# Drop the securemilkcarton database
# This script assumes the database username is root
mysqladmin drop securemilkcarton -f -uroot -p

# Check the exit status
if [ ! $? -eq 0 ]; then
   echo "  > Database deletion failed. Exiting."
   exit 1
fi

# Populate database using securemilkcarton_db.sql file
# This script assumes the database username is root
cat ~/SecureMilkCarton/securemilkcarton/database/securemilkcarton_db.sql | mysql -u root -p

# Check the exit status
if [ ! $? -eq 0 ]; then
   echo "  > Database population failed. Exiting."
   exit 1
fi

echo ">>> Finished."
