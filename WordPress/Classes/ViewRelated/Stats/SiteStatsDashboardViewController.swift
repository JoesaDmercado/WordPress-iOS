import UIKit

class SiteStatsDashboardViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var filterTabBar: FilterTabBar!
    @IBOutlet weak var insightsContainerView: UIView!
    @IBOutlet weak var statsContainerView: UIView!

    private var currentTableDisplayed: UITableView?
    private var insightsTableViewController: SiteStatsInsightsTableViewController?

    // TODO: replace UITableViewController with real controller names that
    // corresponds to DWMY Stats.
    private var statsTableViewController: UITableViewController?

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterBar()
        getSelectedPeriodFromUserDefaults()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let insightsTableVC = segue.destination as? SiteStatsInsightsTableViewController {
            insightsTableViewController = insightsTableVC
        }
    }

}

// MARK: - Private Extension

private extension SiteStatsDashboardViewController {

    struct Constants {
        static let userDefaultsKey = "LastSelectedStatsPeriodType"
        static let progressViewInitialProgress = Float(0.03)
        static let progressViewHideDelay = 1
        static let progressViewHideDuration = 0.15
    }

    enum StatsPeriodType: Int {
        case insights = 0
        case days = 1
        case weeks = 2
        case months = 3
        case years = 4

        static let allPeriods = [StatsPeriodType.insights, .days, .weeks, .months, .years]

        var filterTitle: String {
            switch self {
            case .insights: return NSLocalizedString("Insights", comment: "Title of Insights stats filter.")
            case .days: return NSLocalizedString("Days", comment: "Title of Days stats filter.")
            case .weeks: return NSLocalizedString("Weeks", comment: "Title of Weeks stats filter.")
            case .months: return NSLocalizedString("Months", comment: "Title of Months stats filter.")
            case .years: return NSLocalizedString("Years", comment: "Title of Years stats filter.")
            }
        }
    }

    var currentSelectedPeriod: StatsPeriodType {
        get {
            let selectedIndex = filterTabBar?.selectedIndex ?? StatsPeriodType.insights.rawValue
            return StatsPeriodType(rawValue: selectedIndex) ?? .insights
        }
        set {
            filterTabBar?.setSelectedIndex(newValue.rawValue)
            setContainerViewVisibility()
            setupTableHeaderView()
            saveSelectedPeriodToUserDefaults()
        }
    }

    func setContainerViewVisibility() {
        statsContainerView.isHidden = currentSelectedPeriod == .insights
        insightsContainerView.isHidden = !statsContainerView.isHidden
        currentTableDisplayed = statsContainerView.isHidden ?
                                insightsTableViewController?.tableView :
                                statsTableViewController?.tableView
    }

}

// MARK: - FilterTabBar Support

private extension SiteStatsDashboardViewController {

    func setupFilterBar() {
        WPStyleGuide.Stats.configureFilterTabBar(filterTabBar)
        filterTabBar.items = StatsPeriodType.allPeriods.map { $0.filterTitle }
        filterTabBar.addTarget(self, action: #selector(selectedFilterDidChange(_:)), for: .valueChanged)
    }

    func setupTableHeaderView() {

        guard let currentTableDisplayed = currentTableDisplayed else {
            return
        }

        filterTabBar.translatesAutoresizingMaskIntoConstraints = false

        currentTableDisplayed.tableHeaderView = filterTabBar

        NSLayoutConstraint.activate([
            filterTabBar.centerXAnchor.constraint(equalTo: currentTableDisplayed.centerXAnchor),
            filterTabBar.topAnchor.constraint(equalTo: currentTableDisplayed.topAnchor),
            filterTabBar.widthAnchor.constraint(equalTo: currentTableDisplayed.widthAnchor),
            ])
    }

    @objc func selectedFilterDidChange(_ filterBar: FilterTabBar) {
        currentSelectedPeriod = StatsPeriodType(rawValue: filterBar.selectedIndex) ?? StatsPeriodType.insights

        // TODO: reload view based on selected tab
    }

}

// MARK: - User Defaults Support

private extension SiteStatsDashboardViewController {

    func saveSelectedPeriodToUserDefaults() {
        UserDefaults.standard.set(currentSelectedPeriod.rawValue, forKey: Constants.userDefaultsKey)
    }

    func getSelectedPeriodFromUserDefaults() {

        // TODO: remove this when DWMY is added.
        // Since the filterTabBar is added to tableHeaderView, if DWMY is selected
        // the filterTabBar disappears and you're stuck on an empty view.
        if statsTableViewController == nil {
            currentSelectedPeriod = .insights
        }

        currentSelectedPeriod = StatsPeriodType(rawValue: UserDefaults.standard.integer(forKey: Constants.userDefaultsKey)) ?? .insights
    }
}
