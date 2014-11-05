#/usr/bin/python2
# -*- coding: utf-8 -*-

import sys,codecs,csv
import analytics_auth   # import the Auth Helper class
import datetime
import ast

from geopy.geocoders import Nominatim
from apiclient.errors import HttpError
from oauth2client.client import AccessTokenRefreshError

geolocator = Nominatim()

# Fix for various character encoding errors for output
if sys.stdout.encoding != 'UTF-8':
  sys.stdout = codecs.getwriter('UTF-8')(sys.stdout, 'strict')

def main(argv):
  # Initialize the Analytics Service Object
  service = analytics_auth.initialize_service()

  try:
    # Query APIs, print results
    profile_id = get_profile_id(service)

    if profile_id:
      results = get_results(service, profile_id)
      print_results(results)

  except TypeError, error:
    # Handle errors in constructing a query.
    print ('There was an error in constructing your query : %s' % error)

  except HttpError, error:
    # Handle API errors.
    print ('Arg, there was an API error : %s : %s' %
           (error.resp.status, error._get_reason()))

  except AccessTokenRefreshError:
    # Handle Auth errors.
    print ('The credentials have been revoked or expired, please re-run '
           'the application to re-authorize')


def get_profile_id(service):
  # Get a list of all Google Analytics accounts for this user
  accounts = service.management().accounts().list().execute()

  if accounts.get('items'):
    # Get the first Google Analytics account
    firstAccountId = accounts.get('items')[0].get('id')

    # Get a list of all the Web Properties for the first account
    webproperties = service.management().webproperties().list(accountId=firstAccountId).execute()

    if webproperties.get('items'):
      # Get the first Web Property ID
      firstWebpropertyId = webproperties.get('items')[0].get('id')

      # Get a list of all Views (Profiles) for the first Web Property of the first Account
      profiles = service.management().profiles().list(
          accountId=firstAccountId,
          webPropertyId=firstWebpropertyId).execute()

      if profiles.get('items'):
        # return the first View (Profile) ID
        return profiles.get('items')[0].get('id')

  return None


def get_results(service, profile_id):
  # Use the Analytics Service Object to query the Core Reporting API
  date = datetime.datetime.now()
  usedate = date.strftime('%Y-%m-%d')
  
   
  return service.data().ga().get(
      ids='ga:'+ profile_id,
      start_date='2011-01-01',
      end_date='2011-03-01',
      metrics='ga:sessions',
	  dimensions='ga:country',
	  max_results='10000',
	  sort='-ga:sessions').execute()


def print_results(results):
  # Print data nicely for the user.
  if results:

	#print_report_info(results)
	#print_pagination_info(results)
	#print_profile_info(results)
	#print_query(results)
	#print_column_headers(results)
	#print_totals_for_all_results(results)
  	print_rows(results)
	
  else:
    print 'No results found'


def print_report_info(results):

  print 'Report Infos:'
  print 'Contains Sampled Data = %s' % results.get('containsSampledData')
  print 'Kind                  = %s' % results.get('kind')
  print 'ID                    = %s' % results.get('id')
  print 'Self Link             = %s' % results.get('selfLink')
  print


def print_pagination_info(results):

  print 'Pagination Infos:'
  print 'Items per page = %s' % results.get('itemsPerPage')
  print 'Total Results  = %s' % results.get('totalResults')

  # These only have values if other result pages exist.
  if results.get('previousLink'):
    print 'Previous Link  = %s' % results.get('previousLink')
  if results.get('nextLink'):
    print 'Next Link      = %s' % results.get('nextLink')
  print
'''  
  num_pages = math.ceil(results.get('totalResults')/10000)

  for page_number in range (num_pages)[1:]: 
  '''

def print_profile_info(results):

  print 'Profile Infos:'
  info = results.get('profileInfo')
  print 'Account Id      = %s' % info.get('accountId')
  print 'Web Property Id = %s' % info.get('webPropertyId')
  print 'Profile Id      = %s' % info.get('profileId')
  print 'Table Id        = %s' % info.get('tableId')
  print 'Profile Name    = %s' % info.get('profileName')
  print


def print_query(results):

  print 'Query Parameters:'
  query = results.get('query')
  for key, value in query.iteritems():
    print '%s = %s' % (key, value)
  print


def print_column_headers(results):

  print 'Column Headers:'
  headers = results.get('columnHeaders')
  for header in headers:
    # Print Dimension or Metric name.
    print '\t%s name:    = %s' % (header.get('columnType').title(),
                                  header.get('name'))
    print '\tColumn Type = %s' % header.get('columnType')
    print '\tData Type   = %s' % header.get('dataType')
    print


def print_totals_for_all_results(results):

  print 'Total Metrics For All Results:'
  print 'This query returned %s rows.' % len(results.get('rows'))
  print ('But the query matched %s total results.' %
         results.get('totalResults'))
  print 'Here are the metric totals for the matched total results.'
  totals = results.get('totalsForAllResults')

  for metric_name, metric_total in totals.iteritems():
    print 'Metric Name  = %s' % metric_name
    print 'Metric Total = %s' % metric_total
    print


def print_rows(results):

  #print 'Rows:'
  if results.get('rows', []):
  
    for row in results.get('rows'):
	  
	  # Encodes to ascii to remove unicode marker in array 
	  row0_ascii = row[0].encode('ascii', 'ignore')
	  row1_ascii = row[1].encode('ascii', 'ignore')
	  
	  # Searches for location data on country name
	  location = geolocator.geocode(row[0])
	 
	  try:
		#Creates new array (to remove single quotes)
		new_row = [location.longitude, location.latitude, row1_ascii]
		#new_row = [row0_ascii, location.longitude, location.latitude, row1_ascii]
		
		jointrow = ','.join([str(i) for i in new_row])
		print(jointrow)
	  except AttributeError:
		#uncomment to see missing coordinates
		#print('!!!! Could not locate: '+ row[0] +' !!!!------------------')
		pass

  else:
    print 'No Rows Found'
  
  
if __name__ == '__main__':
  main(sys.argv)

