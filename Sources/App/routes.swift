import Crypto
import Vapor
let kUserBasePath       = "u"
let kMediaBasePath      = "media"
let kPositionBasePath   = "pos"
let kProfileBasePath    = "profile"
let kPlaceBasePath      = "place"
let kEchoBasePath       = "e"
let kEventBasePath      = "event"
let kRelationBasePath   = "rel"
let kMonitorBasePath    = "monitor"
let kChannelBasePath    = "chan"
let kWitnessBasePath    = "witness"
let kRippleBasePath     = "ripple"
let kLoginBasePath      = "login"
let kLogoutBasePath    = "logout"
let kUsersBasePath       = "users"
let kMediasBasePath      = "medias"
let kPositionsBasePath   = "positions"
let kProfilesBasePath    = "profiles"
let kPlacesBasePath      = "places"
let kEchosBasePath       = "echos"
let kEventsBasePath      = "events"
let kRelationsBasePath   = "relations"
let kMonitorsBasePath    = "monitors"
let kChannelsBasePath    = "channels"
let kWitnessesBasePath    = "witnesses"
let kRipplesBasePath     = "ripples"


/// Register your application's routes here.
@available(OSX 10.12, *)
public func routes(_ router: Router) throws {

    
    /*************************** PUBLIC SECTION *************************
     ***
     ***
     ***
     *******************************************************************/
    let userController = UserController()
    /***
     ** Public user end point api spec
     */
    // Creation user
    router.post(kUsersBasePath, use: userController.create)
    

    /*************************** LOGGED USER SECTION *******************
     ***
     ***
     ***
     *******************************************************************/
    
    
    // basic / password auth protected routes
    let basic = router.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
    basic.post(kLoginBasePath, use: userController.login)
    
    // bearer / token auth protected routes
    let bearer = router.grouped(User.tokenAuthMiddleware())
    let todoController = TodoController()
    bearer.get("todos", use: todoController.index)
    bearer.post("todos", use: todoController.create)
    bearer.delete("todos", Todo.parameter, use: todoController.delete)
    
    
    /***
    ** Logged User end point api spec
    */
    router.post(kUsersBasePath, use: userController.create)
    bearer.get(kUserBasePath, User.parameter, use: userController.show)
    bearer.patch(kUserBasePath, User.parameter, use: userController.update)

    /// User Picture CREATE, UPDATE, FETCH, DELETE
    bearer.get(kUserBasePath, User.parameter, "pp", use: userController.updateProfilePicture)
    bearer.post(kUserBasePath, User.parameter, "pp", use: userController.updateProfilePicture)
    bearer.patch(kUserBasePath, User.parameter, "pp", use: userController.updateProfilePicture)
    bearer.delete(kUserBasePath, User.parameter, "pp", use: userController.updateProfilePicture)

    /// User Position CREATE, UPDATE, FETCH
    bearer.get(kUserBasePath, User.parameter, kPositionsBasePath, use: userController.userPositions)
    bearer.post(kUserBasePath, User.parameter, kPositionBasePath, use: userController.addUserPosition)
    bearer.patch(kUserBasePath, User.parameter, kPositionBasePath, Position.parameter, use: userController.updateUserPosition) // Should be never used
    bearer.delete(kUserBasePath, User.parameter, kPositionBasePath, Position.parameter, use: userController.deleteUserPosition)


    /***
     ** Logged Echo end point api spec
     */
    let echoController = EchoController()

    bearer.post(kEchosBasePath, use: echoController.create)
    bearer.patch(kEchosBasePath, use: echoController.update)
    
    
    /***
     ** Logged Place end point api spec
     */
    let placeController = PlaceController()
    
    bearer.post(kPlacesBasePath, use: placeController.create)
    bearer.patch(kPlacesBasePath, use: placeController.update)

    /*************************** ADMIN SECTION *************************
     ***
     ***
     ***
     *******************************************************************/
        
    /** User admin end point api spec
     */

    // Should beon administratif section
    bearer.get("users", use: userController.list)
    
    
    
    
    /// - MARK - Administrative routes
    bearer.get("adm/", kUsersBasePath,  use: userController.list)
}
