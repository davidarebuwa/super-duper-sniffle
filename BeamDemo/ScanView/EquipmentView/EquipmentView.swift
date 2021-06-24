import UIKit


class EquipmentView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var groups = ["Core Burner","Endurance Boost","Body Sculpt","Crossfit+"]
    
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Stability Ball"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
    }
    
    

}
extension EquipmentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(sectionIndex, enviroment) -> NSCollectionLayoutSection?  in
            switch sectionIndex {
            case 0:
                //Description
                let size  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(125))
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
            case 1:
                //Type Header
                let size  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
                let item = NSCollectionLayoutItem(layoutSize: size)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section

            default:
               //Body
                let width = enviroment.container.contentSize.width - 30
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width / 2.0), heightDimension: .absolute(width / 2.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width + 30), heightDimension: .absolute((width / 2.0) + 10))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
            }
        }
            return layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 2 ? 4 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "equipmentDescriptionCell", for: indexPath)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseTypesHeaderCell", for: indexPath) as! ExerciseTypeHeaderCell
            let attributed = NSMutableAttributedString(string: "Fat Loss\n", attributes: [
                            .foregroundColor: UIColor.label,
                            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
                        ])
                        attributed.append(NSAttributedString(string: "Edit", attributes: [
                            .foregroundColor: UIColor.systemBlue,
                            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
                        ]))
            cell.titleView.attributedText = attributed
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseOptionCell", for: indexPath) as! ExerciseOptionCell
            let attributed = NSMutableAttributedString(string: "\(groups[indexPath.row])\n", attributes: [
                            .foregroundColor: UIColor.label,
                            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
                        ])
                        attributed.append(NSAttributedString(string: "8 workouts | 10 mins", attributes: [
                            .foregroundColor: UIColor.secondaryLabel,
                            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
                        ]))
            cell.titleView.attributedText = attributed
            cell.iconView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            performSegue(withIdentifier: "goToExercise", sender: self)
        }
    }


    
}

