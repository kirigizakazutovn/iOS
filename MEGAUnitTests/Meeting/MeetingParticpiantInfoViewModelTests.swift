import XCTest
@testable import MEGA

final class MeetingParticpiantInfoViewModelTests: XCTestCase {
    
    func testAction_onViewReady_MyselfAsModerator_ParticipantIsAModeratorAndIsInContactList() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100, isModerator: true, isInContactList: true, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()

        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [infoAction(), sendMessageAction(), removeModeratorAction(), removeContactAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_onViewReady_MyselfAsModerator_ParticipantIsAModeratorAndNotInContactList() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: true, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [removeModeratorAction(), removeContactAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_onViewReady_MyselfAsModerator_ParticipantIsNotAModeratorAndAlsoInContactList() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: true, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [infoAction(), sendMessageAction(), makeModeratorAction(), removeContactAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_onViewReady_MyselfAsModerator_ParticipantIsNotAModeratorAndNotInContactList() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [makeModeratorAction(), removeContactAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_onViewReady_MyselfAsParticipant_ParticipantIsNotAModeratorAndAlsoInContactList() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: true, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: false,
                                                        router: router)
        
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [infoAction(), sendMessageAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_onViewReady_MyselfAsParticipant_ParticipantIsNotAModeratorAndNotInContactList() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: false,
                                                        router: router)
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [infoAction(), sendMessageAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_onViewReady_ParticipantIsAGuest() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        test(viewModel: viewModel,
             action: .onViewReady,
             expectedCommands: [
                .configView(email: "test@email.com", actions: [makeModeratorAction(), removeContactAction()]),
                .updateName(name: "Test"),
                .updateAvatarImage(image: UIImage())
             ])
    }
    
    func testAction_showInfo() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        viewModel.dispatch(.showInfo)
        XCTAssert(router.showInfo_calledTimes == 1)
    }
    
    func testAction_sendMessage() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomEntity = ChatRoomEntity(ownPrivilege: .moderator, chatType: .meeting)
        let chatRoomUseCase = MockChatRoomUseCase(chatRoomEntity: chatRoomEntity)
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        viewModel.dispatch(.sendMessage)
        XCTAssert(router.openChatRoom_calledTimes == 1)
    }
    
    func testAction_addToContact_success() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        viewModel.dispatch(.addToContact)
        XCTAssert(router.showInviteSuccess_calledTimes == 1)
    }
    
    func testAction_addToContact_error() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .failure(.generic(""))),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        viewModel.dispatch(.addToContact)
        XCTAssert(router.showInviteErrorMessage_calledTimes == 1)
    }
    
    func testAction_makeModerator() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        viewModel.dispatch(.makeModerator)
        XCTAssert(router.makeParticipantAsModerator_calledTimes == 1)
    }
    
    func testAction_removeParticipant() {
        let participant = CallParticipantEntity(chatId: 100, participantId: 100, clientId: 100,  isModerator: false, isInContactList: false, canReceiveVideoHiRes: true)
        let chatRoomUseCase = MockChatRoomUseCase(userDisplayNameCompletion: .success("Test"))
        let userImageUseCase = MockUserImageUseCase(result: .success(UIImage()))
        let router = MockMeetingParticpiantInfoViewRouter()
        
        
        let viewModel = MeetingParticpiantInfoViewModel(participant: participant,
                                                        userImageUseCase: userImageUseCase,
                                                        chatRoomUseCase: chatRoomUseCase,
                                                        userInviteUseCase: MockUserInviteUseCase(result: .success),
                                                        isMyselfModerator: true,
                                                        router: router)
        
        viewModel.dispatch(.removeParticipant)
        XCTAssert(router.removeParticipant_calledTimes == 1)
    }
    
    //MARK:- Private methods
    
    private func infoAction() -> ActionSheetAction {
        ActionSheetAction(title: Strings.Localizable.info,
                          detail: nil,
                          image: Asset.Images.Meetings.infoMeetings.image,
                          style: .default) {}
    }
    
    private func sendMessageAction() -> ActionSheetAction {
        ActionSheetAction(title: Strings.Localizable.sendMessage,
                          detail: nil,
                          image: Asset.Images.Meetings.sendMessageMeetings.image,
                          style: .default) {}
    }
    
    private func makeModeratorAction() -> ActionSheetAction {
        ActionSheetAction(title: Strings.Localizable.Meetings.Participant.makeModerator,
                          detail: nil,
                          image: Asset.Images.Meetings.moderatorMeetings.image,
                          style: .default) {}
    }
    
    private func removeModeratorAction() -> ActionSheetAction {
        ActionSheetAction(title: Strings.Localizable.Meetings.Participant.removeModerator,
                          detail: nil,
                          image: Asset.Images.Meetings.moderatorMeetings.image,
                          style: .default) {}
    }
    
    private func addContactAction() -> ActionSheetAction {
        ActionSheetAction(title: Strings.Localizable.addContact,
                          detail: nil,
                          image: Asset.Images.Meetings.addContactMeetings.image,
                          style: .default) {}
    }
    
    private func removeContactAction() -> ActionSheetAction {
        ActionSheetAction(title: Strings.Localizable.removeParticipant,
                          detail: nil,
                          image: Asset.Images.NodeActions.delete.image,
                          style: .destructive) {}
    }
}

final class MockMeetingParticpiantInfoViewRouter: MeetingParticpiantInfoViewRouting {
    var showInfo_calledTimes = 0
    var openChatRoom_calledTimes = 0
    var showInviteSuccess_calledTimes = 0
    var showInviteErrorMessage_calledTimes = 0
    var makeParticipantAsModerator_calledTimes = 0
    var removeParticipantAsModerator_calledTimes = 0
    var removeParticipant_calledTimes = 0

    func showInfo() {
        showInfo_calledTimes += 1
    }
    
    func openChatRoom(withChatId chatId: UInt64) {
        openChatRoom_calledTimes += 1
    }
    
    func showInviteSuccess(email: String) {
        showInviteSuccess_calledTimes += 1
    }
    
    func showInviteErrorMessage(_ message: String) {
        showInviteErrorMessage_calledTimes += 1
    }
    
    func makeParticipantAsModerator() {
        makeParticipantAsModerator_calledTimes += 1
    }
        
    func removeModeratorPrivilage() {
        removeParticipantAsModerator_calledTimes += 1
    }
    
    func removeParticipant() {
        removeParticipant_calledTimes += 1
    }
}
