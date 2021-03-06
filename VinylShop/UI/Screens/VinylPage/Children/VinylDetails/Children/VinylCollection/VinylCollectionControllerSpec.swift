@testable import VinylShop
import Nimble
import Quick
import SpecTools
import UIKit

class VinylCollectionControllerSpec: QuickSpec {

    override func spec() {
        describe("VinylCollectionController") {
            var sut: VinylCollectionController!

            beforeEach {
                let viewModel = vinylRecommendedViewModelFactory(.testVinyl)
                sut = VinylCollectionController(viewModel: viewModel)
            }

            afterEach {
                sut = nil
            }

            describe("required initializer") {
                it("should return nil") {
                    expect(VinylCollectionController(coder: NSCoder())).to(beNil())
                }
            }

            describe("view did load") {
                beforeEach {
                    _ = sut.view
                }

                it("should have title set") {
                    expect(sut.vinylsView.titleLabel.text) == "RECOMMENDED FOR YOU"
                }

                describe("collection view") {
                    var collectionView: UICollectionView!

                    beforeEach {
                        collectionView = sut.vinylsView.collectionView
                    }

                    afterEach {
                        collectionView = nil
                    }

                    it("should have layout set") {
                        expect(collectionView.collectionViewLayout) === sut.vinylsView.collectionViewLayout
                    }

                    it("should have 1 section") {
                        expect(collectionView.dataSource?.numberOfSections?(in: collectionView)) == 1
                    }

                    describe("1st section") {
                        it("should have 3 items") {
                            expect(collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)) == 3
                        }

                        describe("1st cell") {
                            var cell: VinylCollectionCell?
                            var size: CGSize!

                            beforeEach {
                                cell = collectionView.cell(inSection: 0, atItem: 0)
                                size = collectionView.size(inSection: 0, atItem: 0)
                            }

                            afterEach {
                                cell = nil
                                size = nil
                            }

                            it("should be dequeued") {
                                expect(cell).toNot(beNil())
                            }

                            it("should have correct title") {
                                expect(cell?.titleLabel.text) == "Master of Puppets"
                            }

                            it("should have correct band") {
                                expect(cell?.bandLabel.text) == "Metallica"
                            }

                            it("should have correct image") {
                                expect(cell?.coverImageView.image).to(beImage(#imageLiteral(resourceName: "cover_metallica")))
                            }

                            it("should have correct size") {
                                expect(size) == CGSize(width: 114, height: 180)
                            }

                            describe("tap") {
                                var invokedVinylSelectedAction: Vinyl?

                                beforeEach {
                                    sut.vinylSelectedAction = { invokedVinylSelectedAction = $0 }
                                    collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
                                }

                                afterEach {
                                    invokedVinylSelectedAction = nil
                                }

                                it("should invoke vinyl selected action") {
                                    expect(invokedVinylSelectedAction).toNot(beNil())
                                    expect(invokedVinylSelectedAction?.title) == "Master of Puppets"
                                    expect(invokedVinylSelectedAction?.band) == "Metallica"
                                }
                            }
                        }
                    }
                }

                describe("cell for vinyl ID") {
                    var cell: VinylCollectionCell?

                    beforeEach {
                        sut.spec.prepare.set(viewSize: .iPhone5)
                    }

                    afterEach {
                        cell = nil
                    }

                    describe("with existing and visible vinyl ID") {
                        beforeEach {
                            cell = sut.visibleCell(forVinylID: 2)
                        }

                        it("should return a cell") {
                            expect(cell).toNot(beNil())
                        }

                        it("should return cell for Stromae - Papaoutai") {
                            expect(cell?.titleLabel.text) == "Papaoutai"
                            expect(cell?.bandLabel.text) == "Stromae"
                        }
                    }

                    describe("with non-existing vinyl ID") {
                        beforeEach {
                            cell = sut.visibleCell(forVinylID: 6_666)
                        }

                        it("should NOT return a cell") {
                            expect(cell).to(beNil())
                        }
                    }
                }
            }
        }
    }

}
