//
//  HealthKitManager.swift
//  ClimatePro
//
//  Created by Will on 2026-03-28.
//
// This impliments HealthKit in Swift

import Foundation
import HealthKit

class HealthKitManager {

    static let shared = HealthKitManager()

    let healthStore = HKHealthStore()

    // MARK: - Authorization

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {

        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        // request workout access instead
        let workoutType = HKObjectType.workoutType()

        let readTypes: Set = [
            workoutType
        ]

        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    // MARK: - Data Model

    struct TransportActivity {
        let type: String
        let distanceKM: Double
        let icon: String
        let points: Int
    }

    // MARK: - Fetch Activities (WORKOUT-BASED)

    func fetchTransportationActivitiesForLast7Days(completion: @escaping ([TransportActivity]) -> Void) {

        var results: [TransportActivity] = []

        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)

        let query = HKSampleQuery(
            sampleType: HKObjectType.workoutType(),
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { _, samples, error in

            guard let workouts = samples as? [HKWorkout] else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            for workout in workouts {

                // Skip if no distance
                guard let distance = workout.totalDistance?.doubleValue(for: .meter()) else { continue }

                let km = distance / 1000.0

                // ROUND TO 2 DECIMALS
                let roundedKM = Double(round(km * 100) / 100)

                // Optional: ignore tiny movements
                if roundedKM < 0.2 { continue }

                var type = ""
                var icon = ""

                switch workout.workoutActivityType {

                case .walking:
                    type = "Walk"
                    icon = "figure.walk"

                case .running:
                    type = "Run"
                    icon = "figure.run"

                case .cycling:
                    type = "Bike Ride"
                    icon = "bicycle"

                default:
                    continue
                }

                results.append(
                    TransportActivity(
                        type: type,
                        distanceKM: roundedKM,
                        icon: icon,
                        points: Int(roundedKM * 3)
                    )
                )
            }

            DispatchQueue.main.async {
                completion(results)
            }
        }

        healthStore.execute(query)
    }
}
