class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateReportException extends CloudStorageExceptions {}

class CouldNotGetAllReportsException extends CloudStorageExceptions {}

class CouldNotUpdateReportException extends CloudStorageExceptions {}

class CouldNotDeleteReportException extends CloudStorageExceptions {}

class CouldNotAddUserException extends CloudStorageExceptions {}

class CouldNotGetChatRoomsException extends CloudStorageExceptions {}

class CouldNotCreateChats extends CloudStorageExceptions {}

class CouldNotSendMessage extends CloudStorageExceptions {}

class CouldNotAddContact extends CloudStorageExceptions {}

class CouldNotUpdateChat extends CloudStorageExceptions {}
