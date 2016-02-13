var request = require('request');
var cheerio = require('cheerio');
var app = require('../../server');


/* Root Rides */
app.get('/rides', function (req, res) {

  return res.json(
    {
      results: [
        {
          info: 'This is an api for requests for rides/passengers in Iceland',
          endpoints: {
            'samferda-drivers':    '/rides/samferda-drivers/',
            'samferda-passengers': '/rides/samferda-passengers/'
          }
        }
      ]
    }
  );
});



var scrapeSamferdaFor = function (requesting, res) {

	var url = 'http://www.samferda.net/';

	request(url, function (error, response, body) {
		if (error) {
			return res.status(500).json({error: url + ' not responding correctly...' });
		}

		// Cheerio declared and then attemted to load.
		var $;
		try {
			$ = cheerio.load( body );
		} catch (e) {
			return res.status(500).json({error:'Could not load the body with cherrio.'});
		}

		// Base object to be added to
		// and eventually sent as a JSON response.
		var results = [];

		$('table:has(thead) > tbody > tr[bgcolor]').each(function() {
			var cols = $(this).children();
			var rowType = cols.eq(1).text().trim();

			if ( rowType === requesting ) {
				results.push({
					link: cols.eq(0).find('a').attr('href'),
					from: cols.eq(2).text().trim(),
					to:   cols.eq(3).text().trim(),
					date: cols.eq(4).text().trim().split('.').reverse().join('-'), // convert to YYYY-MM-DD for easier sorting
					time: cols.eq(5).text().trim()
				});
			}
		});

		return res.cache(1800).json({ results:results });
	});

};

/**
 * Fetches list of Passenger requests on Samferda.net.
 * response - JSON: Passenger requests within an 'results' array.
 */
app.get('/rides/samferda-drivers', function (req, res, next) {
	scrapeSamferdaFor('Passengers', res);
});
/**
 * Fetches list of Ride requests on Samferda.net.
 * response - JSON: Ride requests within an 'results' array.
 */
app.get('/rides/samferda-passengers', function (req, res, next) {
	scrapeSamferdaFor('Ride', res);
});
