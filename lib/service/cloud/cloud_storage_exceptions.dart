class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateReportException extends CloudStorageExceptions {}

class CouldNotGetReportException extends CloudStorageExceptions {}

class CouldNotGetAllReportsException extends CloudStorageExceptions {}

class CouldNotUpdateReportException extends CloudStorageExceptions {}

class CouldNotDeleteReportException extends CloudStorageExceptions {}

class CouldNotAddUserException extends CloudStorageExceptions {}

class CouldNotCreateAdvocateException extends CloudStorageExceptions {}