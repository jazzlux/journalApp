import XCTest
import Vapor
@testable import App

class AppTests: XCTestCase {
    func testStub() throws {
        XCTAssert(true)
    }
    
    static let allTests = [
        ("testStub", testStub),
    ]
    
//    func testStudent() throws { // [3]
//    let myApp = try app(Environment.testing) // [4]
//        let studentRecords = [ // [5]
//    "Peter" : 3.42, "Thomas" : 2.98, "Jane" : 3.91, "Ryan" : 4.00, "Kyle" : 4.00
//    ]
//        
//    for (studentName, gpa) in studentRecords { // [6]
//    let query = "/student/" + studentName;
//    let request = Request(http: HTTPRequest(method: .GET, url: URL(string:query)!),using: myApp)
//    // [8]
//    let response = try myApp.make(Responder.self).respond(to: request).wait()\(gpa)"
//    } }
//    guard let data = response.http.body.data else { XCTFail("No data in response")
//        return
//    }
//    let expectedResponse = "The student \(studentName)'s GPA is
//    // [10]
//    if let responseString = String(data: data, encoding: .utf8) {
//        XCTAssertEqual(responseString, expectedResponse)
//    }
//    static let allTests = [ ("testNothing", testNothing), ("testStudent", testStudent)
//    ]
//    
    
}

