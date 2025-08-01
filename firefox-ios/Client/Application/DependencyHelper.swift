// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Storage
import Common

class DependencyHelper {
    @MainActor
    func bootstrapDependencies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // Fatal error here so we can gather info as this would cause a crash down the line anyway
            fatalError("Failed to register any dependencies")
        }

        let profile: Profile = appDelegate.profile
        AppContainer.shared.register(service: profile as Profile)

        AppContainer.shared.register(service: appDelegate.searchEnginesManager)

        let diskImageStore: DiskImageStore =
        DefaultDiskImageStore(files: profile.files,
                              namespace: TabManagerConstants.tabScreenshotNamespace,
                              quality: UIConstants.ScreenshotQuality)
        AppContainer.shared.register(service: diskImageStore as DiskImageStore)

        let appSessionProvider: AppSessionProvider = appDelegate.appSessionManager
        AppContainer.shared.register(service: appSessionProvider as AppSessionProvider)

        let downloadQueue: DownloadQueue = appDelegate.appSessionManager.downloadQueue
        AppContainer.shared.register(service: downloadQueue)

        let windowManager: WindowManager = appDelegate.windowManager
        AppContainer.shared.register(service: windowManager as WindowManager)

        let themeManager: ThemeManager = appDelegate.themeManager
        AppContainer.shared.register(service: themeManager as ThemeManager)

        let microsurveyManager: MicrosurveyManager = MicrosurveySurfaceManager()
        AppContainer.shared.register(service: microsurveyManager as MicrosurveyManager)

        let merinoManager: MerinoManagerProvider = MerinoManager(
            merinoAPI: MerinoProvider(prefs: profile.prefs)
        )
        AppContainer.shared.register(service: merinoManager as MerinoManagerProvider)

        let documentLogger = appDelegate.documentLogger
        AppContainer.shared.register(service: documentLogger)

        let gleanUsageReportingMetricsService: GleanUsageReportingMetricsService =
        appDelegate.gleanUsageReportingMetricsService
        AppContainer.shared.register(service: gleanUsageReportingMetricsService)

        // Tell the container we are done registering
        AppContainer.shared.bootstrap()
    }
}
