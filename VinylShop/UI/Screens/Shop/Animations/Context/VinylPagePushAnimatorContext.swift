import UIKit

struct VinylPagePushAnimatorContext {
    let shopController: ShopController
    let pageController: VinylPageController
    let vinylCell: VinylCollectionCell
    let coverSnapshotView: UIView

    init?(vinylID: Int, transitionContext: UIViewControllerContextTransitioning) {
        guard let shopController = transitionContext.viewController(forKey: .from) as? ShopController,
              let pageController = transitionContext.viewController(forKey: .to) as? VinylPageController,
              let vinylCell = findVinylCell(forVinylID: vinylID, in: shopController),
              let coverSnapshotView = vinylCell.coverImageView.snapshotView(afterScreenUpdates: true) else {
            return nil
        }

        self.shopController = shopController
        self.pageController = pageController
        self.vinylCell = vinylCell
        self.coverSnapshotView = coverSnapshotView
    }

}
