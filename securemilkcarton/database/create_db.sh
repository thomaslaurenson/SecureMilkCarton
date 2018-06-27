echo ">>> Creating database"

echo ">>> Starting population of database for secure milk carton..."

# Populate database using securemilkcarton_db.sql file
# This script assumes the database username is root
cat ~/SecureMilkCarton/securemilkcarton/database/securemilkcarton_db.sql | mysql -u root -p

# Check the exit status
if [ ! $? -eq 0 ]; then
   echo "  > Database population failed. Exiting."
   exit 1
fi

echo ">>> Finished."