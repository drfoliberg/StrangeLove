package analytics.constants;

public class ErrorCodes {
	public static final byte OK = 0, // normal response
			BAD_CGMINER = 1, // cgminer error (from wrapper)
			NO_CGMINER = 2, // could not reach cgminer (from wrapper)
			CONFIG_ERROR = 3, // config of cgminer wrapper not sane (from wrapper)
			TIME_DISRUPTION = 4, // timestamp is not sane with last record
			MINER_TIMEOUT = 5, // could not reach miner
			NO_LAST_RECORD = 6, // no previous record found for the card/server
			MINER_REBOOTED = 7, // previous record does not make sense. Miner must have rebooted.
			UNEXPECTED_SERVER_ID = 8, // the server id returned from the miner was the same as the dispatcher expected
			RESPONSE_MISSING_KEY = 9, // the json objet returned by the wrapper does not have all required keys
			SQL_ERROR = 10, // An SQL related error occurred
			UNKNOWN = 42;
}
