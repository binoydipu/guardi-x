class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateReportException extends CloudStorageExceptions {}

class CouldNotGetReportException extends CloudStorageExceptions {}

class CouldNotGetAllReportsException extends CloudStorageExceptions {}

class CouldNotUpdateReportException extends CloudStorageExceptions {}

class CouldNotDeleteReportException extends CloudStorageExceptions {}

class CouldNotAddUserException extends CloudStorageExceptions {}

class CouldNotGetUserException extends CloudStorageExceptions {}

class CouldNotCreateAdvocateException extends CloudStorageExceptions {}

class CouldNotDeleteAdvocateException extends CloudStorageExceptions {}

class CouldNotCreateLawException extends CloudStorageExceptions {}

class CouldNotDeleteLawException extends CloudStorageExceptions {}

class CouldNotUpdateLawException extends CloudStorageExceptions {}

class CouldNotAddCommentException extends CloudStorageExceptions {}

class CouldNotDeleteCommentException extends CloudStorageExceptions {}

class CouldNotGetChatRoomsException extends CloudStorageExceptions {}

class CouldNotCreateChats extends CloudStorageExceptions {}

class CouldNotSendMessage extends CloudStorageExceptions {}

class CouldNotAddContact extends CloudStorageExceptions {}

class CouldNotUpdateChat extends CloudStorageExceptions {}