//
//  ExpenseNotesSpanshotTests.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import XCTest
 import FeediOS
 @testable import Feed

 class ExpenseNotesSnapshotTests: XCTestCase {

     func test_listWithComments() {
         let sut = makeSUT()

         sut.display(comments())

         assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EXPENSE_NOTES_light")
         assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EXPENSE_NOTES_dark")
     }

     // MARK: - Helpers

     private func makeSUT() -> ListViewController {
         let bundle = Bundle(for: ListViewController.self)
         let storyboard = UIStoryboard(name: "ExpenseNotes", bundle: bundle)
         let controller = storyboard.instantiateInitialViewController() as! ListViewController
         controller.loadViewIfNeeded()
         controller.tableView.showsVerticalScrollIndicator = false
         controller.tableView.showsHorizontalScrollIndicator = false
         return controller
     }

     private func comments() -> [CellController] {
         return [
             ExpenseNoteCellController(
                 model: ExpenseNoteViewModel(
                     message: "I paid for her too, that's why it cost me twice as much",
                     date: "2 years ago"
                 )
             ),
             ExpenseNoteCellController(
                 model: ExpenseNoteViewModel(
                     message: "I paid in cash",
                     date: "10 days ago"
                 )
             ),
             ExpenseNoteCellController(
                 model: ExpenseNoteViewModel(
                     message: "Gotta change the oil in 2 months",
                     date: "1 hour ago"
                 )
             ),
         ]
     }

 }
