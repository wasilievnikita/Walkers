
import UIKit
class LaunchVC: UIViewController {
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    
    private lazy var welcomeText: UILabel = {
        let label = UILabel(frame: CGRect(x: view.frame.size.width/2 - 100, y: view.frame.size.height + 50, width: 300, height: 30))
        label.text = "Find your Walker!"
        label.textColor = .black
        label.font = UIFont(name: "Khmer Sangam MN", size: 30)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addBackground()
        animatew()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 , execute: {
            self.animatew()
        })
    }
    
    // MARK: - Setup layout
    
    func layout() {
        view.addSubview(avatar)
        view.addSubview(welcomeText)
        
        let inset: CGFloat = 200
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1.1 * inset),
            avatar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatar.heightAnchor.constraint(equalToConstant: inset),
            avatar.widthAnchor.constraint(equalToConstant: inset)])
    }
    
    // MARK: - Add wallpaper
    
    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "wP_launch")
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
    }
    
    // MARK: - Animation
    
    private func animatew() {
        UIView.animate(withDuration: 1.5 ) {
            
            self.welcomeText.frame = CGRect(x: self.view.frame.size.width/2 - self.welcomeText.bounds.width/3, y: self.view.frame.size.height - 80, width: 300, height: 30)
            
        } completion: { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {
                let profileViewController = ProfileViewController()
                let mapViewController = MapViewController()
//                let chatsVC = Chat()
                
                let profileNavViewController = UINavigationController(rootViewController: profileViewController)
                let mapNavViewController = UINavigationController(rootViewController:mapViewController)
//                let chatsNavVC = UINavigationController(rootViewController:chatsVC)
                
                mapNavViewController.tabBarItem.title = "Поиск"
                mapNavViewController.tabBarItem.image = UIImage(named: "search-3")
                
                profileNavViewController.tabBarItem.title = "Мой профиль"
                profileNavViewController.tabBarItem.image = UIImage(named: "user")
                
//                chatsNavVC.tabBarItem.title = "Чаты"
//                chatsNavVC.tabBarItem.image = UIImage(named: "messages")
                
                mapNavViewController.tabBarItem.title = "Поиск"
                mapNavViewController.tabBarItem.image = UIImage(named: "search")
                
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [mapNavViewController, profileNavViewController]
                tabBarController.tabBar.backgroundColor = .white
                tabBarController.modalTransitionStyle = .crossDissolve
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true)
            }
            )
        }
    }
    
}

// MARK: - Add gradient of wallpapers

extension LaunchVC {
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [color, UIColor.systemGray6.cgColor]
        view.layer.insertSublayer(gradient, at: 100)
    }
}
