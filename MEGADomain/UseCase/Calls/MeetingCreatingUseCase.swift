// MARK: - Use case protocol -
protocol MeetingCreatingUseCaseProtocol {
    func startCall(meetingName: String, enableVideo: Bool, enableAudio: Bool, completion: @escaping (Result<ChatRoomEntity, CallErrorEntity>) -> Void)
    func joinCall(forChatId chatId: UInt64, enableVideo: Bool, enableAudio: Bool, userHandle: UInt64, completion: @escaping (Result<ChatRoomEntity, CallErrorEntity>) -> Void)
    func getUsername() -> String
    func getCall(forChatId chatId: UInt64) -> CallEntity?
    func createEphemeralAccountAndJoinChat(firstName: String, lastName: String, link: String, completion: @escaping (Result<Void, MEGASDKErrorType>) -> Void, karereInitCompletion: @escaping () -> Void)
    func checkChatLink(link: String, completion: @escaping (Result<ChatRoomEntity, CallErrorEntity>) -> Void)
    func createChatLink(forChatId chatId: UInt64)
}

// MARK: - Use case implementation -
struct MeetingCreatingUseCase: MeetingCreatingUseCaseProtocol {

    private let repository: MeetingCreatingRepositoryProtocol
    
    init(repository: MeetingCreatingRepositoryProtocol) {
        self.repository = repository
    }
    
    func startCall(meetingName: String, enableVideo: Bool, enableAudio: Bool,  completion: @escaping (Result<ChatRoomEntity, CallErrorEntity>) -> Void) {
        repository.startChatCall(meetingName: meetingName, enableVideo: enableVideo, enableAudio: enableAudio, completion: completion)
    }
    
    func joinCall(forChatId chatId: UInt64, enableVideo: Bool, enableAudio: Bool, userHandle: UInt64, completion: @escaping (Result<ChatRoomEntity, CallErrorEntity>) -> Void) {
        repository.joinChatCall(forChatId: chatId, enableVideo: enableVideo, enableAudio: enableAudio, userHandle: userHandle, completion: completion)
    }
    
    func getUsername() -> String {
        repository.getUsername()
    }
    
    func getCall(forChatId chatId: UInt64) -> CallEntity? {
        repository.getCall(forChatId: chatId)
    }
    
    func createChatLink(forChatId chatId: UInt64) {
        repository.createChatLink(forChatId: chatId)
    }
    
    func checkChatLink(link: String, completion: @escaping (Result<ChatRoomEntity, CallErrorEntity>) -> Void) {
        repository.checkChatLink(link: link, completion: completion)
    }

    func createEphemeralAccountAndJoinChat(firstName: String, lastName: String, link: String, completion: @escaping (Result<Void, MEGASDKErrorType>) -> Void, karereInitCompletion: @escaping () -> Void) {
        repository.createEphemeralAccountAndJoinChat(firstName: firstName, lastName: lastName, link: link, completion: completion, karereInitCompletion: karereInitCompletion)
    }
    
}
