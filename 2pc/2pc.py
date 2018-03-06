import psycopg2 as ps
import os

tpc_flights = ps.connect(dbname = "tpc_flights", user = "postgres", password = os.environ['PG_PASS'], host = "localhost")
tpc_hotels = ps.connect(dbname ="tpc_hotels", user ="postgres", password = os.environ['PG_PASS'], host ="localhost")
tpc_accounts = ps.connect(dbname = "tpc_accounts", user = "postgres", password = os.environ['PG_PASS'], host = "localhost")

tpc_flights.tpc_begin(tpc_flights.xid(32, 'foobar', 'tpc_flights_bqual'))
tpc_hotels.tpc_begin(tpc_hotels.xid(32, 'foobar', 'tpc_hotels_bqual'))
tpc_accounts.tpc_begin(tpc_accounts.xid(32, 'foobar', 'tpc_accounts_bqual'))

cursor_flights = tpc_flights.cursor()
cursor_hotels = tpc_hotels.cursor()
cursor_accounts = tpc_accounts.cursor()

cursor_flights.execute('INSERT INTO flights("Client Name", "Fly Number", "From", "To", "Date") VALUES (\'NIK\', \'SSPP21\', \'SALSA\', \'TANGO\', \'03/04/2018\');')
cursor_hotels.execute('INSERT INTO hotels("Client Name", "Hotel Name", "Arrival", "Departure") VALUES (\'NIK\', \'PPPP\', \'01/01/2017\', \'01/03/2018\');')
cursor_accounts.execute('UPDATE accounts SET "Amount" = "Amount" - 200 WHERE "Account ID"=1');

try:
    tpc_flights.tpc_prepare()
    tpc_hotels.tpc_prepare()
    tpc_accounts.tpc_prepare()
except ps.DatabaseError as e:
    print(e)
    tpc_flights.tpc_rollback()
    tpc_hotels.tpc_rollback()
    tpc_accounts.tpc_rollback()
else:
    tpc_flights.tpc_commit()
    tpc_hotels.tpc_commit()
    tpc_accounts.tpc_commit()