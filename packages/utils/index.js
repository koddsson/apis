/*
 * We'd like to do ethical scraping and let the webmasters know that
 * we are a bot so that they can take action if they don't like us scraping
 * their data.
 *
 * In the future if we're feeling militant about our rights to scrape data,
 * if any, we might add a function to pretend to be a normal browser in order
 * for sites not to block us.
 *
 * Inspiration taken from https://support.google.com/webmasters/answer/1061943?hl=en
 *
 * TODO: Change that URL before landing on master
 */
export const apisUserAgent = (
  'Mozilla/5.0 (compatible; Apisbot/0.1; +https://github.com/koddsson/apis/blob/master/apis-bot.md)'
)
