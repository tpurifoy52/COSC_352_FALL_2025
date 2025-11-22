{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Lazy as BL
import qualified Data.Vector as V
import Data.Csv
import qualified Data.Map.Strict as Map
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

data Homicide = Homicide
  { homicideNo          :: String
  , dateDied            :: String
  , victimName          :: String
  , victimAge           :: String
  , addressBlock        :: String
  , notes               :: String
  , noViolentHistory    :: String
  , surveillanceCamera  :: String
  , caseClosed          :: String
  , sourcePage          :: String
  , year                :: Int
  , latitude            :: String
  , longitude           :: String
  } deriving (Show, Eq)

instance FromNamedRecord Homicide where
  parseNamedRecord r = Homicide
    <$> r .: "No."
    <*> r .: "Date Died"
    <*> r .: "Name"
    <*> r .: "Age"
    <*> r .: "Address Block Found"
    <*> r .: "Notes"
    <*> r .: "Victim Has No Violent Criminal History"
    <*> r .: "Surveillance Camera At Intersection"
    <*> r .: "Case Closed"
    <*> r .: "source_page"
    <*> r .: "year"
    <*> r .: "lat"
    <*> r .: "lon"

homicidesPerYear :: [Homicide] -> Map.Map Int Int
homicidesPerYear = foldr countYear Map.empty
  where
    countYear h = Map.insertWith (+) (year h) 1

topLocations :: Int -> [Homicide] -> [(String, Int)]
topLocations n homicides =
  take n 
  . sortBy (comparing (Down . snd))
  . Map.toList 
  $ locationCounts
  where
    locationCounts = foldr countLocation Map.empty homicides
    countLocation h = Map.insertWith (+) (cleanAddress $ addressBlock h) 1
    cleanAddress addr = if null addr || addr == "" then "Unknown Location" else addr

closureAnalysis :: [Homicide] -> (Int, Int, Double)
closureAnalysis homicides = (totalCases, closedCases, closureRate)
  where
    totalCases = length homicides
    closedCases = length $ filter isClosed homicides
    isClosed h = caseClosed h == "Yes" || caseClosed h == "Y"
    closureRate = if totalCases > 0 
                  then (fromIntegral closedCases / fromIntegral totalCases) * 100 
                  else 0.0

calculateTrend :: Map.Map Int Int -> String
calculateTrend yearMap
  | Map.null yearMap = "No data available"
  | otherwise = 
      let years = Map.keys yearMap
          minYear = minimum years
          maxYear = maximum years
          startCount = Map.findWithDefault 0 minYear yearMap
          endCount = Map.findWithDefault 0 maxYear yearMap
          change = endCount - startCount
          percentChange = if startCount > 0 
                         then (fromIntegral change / fromIntegral startCount) * 100 :: Double
                         else 0
      in "From " ++ show minYear ++ " to " ++ show maxYear ++ ": " 
         ++ show change ++ " change (" 
         ++ show (round percentChange :: Int) ++ "% change)"

getYearRange :: [Homicide] -> (Int, Int)
getYearRange [] = (0, 0)
getYearRange homicides = (minimum years, maximum years)
  where
    years = map year homicides

formatYearlyData :: Map.Map Int Int -> String
formatYearlyData m = unlines $
  ["=" ++ replicate 60 '=',
   "ANALYSIS 1: HOMICIDES PER YEAR",
   "=" ++ replicate 60 '='] ++
  map (\(y, count) -> show y ++ ": " ++ show count ++ " homicides") 
      (Map.toList m) ++
  ["", "Trend Analysis: " ++ calculateTrend m]

formatTopLocations :: [(String, Int)] -> String
formatTopLocations locs = unlines $
  ["", "=" ++ replicate 60 '=',
   "ANALYSIS 2: TOP 10 MOST DANGEROUS LOCATIONS",
   "=" ++ replicate 60 '='] ++
  zipWith formatRanking [1..] locs
  where
    formatRanking i (loc, c) = 
      show i ++ ". " ++ take 50 loc ++ ": " ++ show c ++ " homicides"

formatClosureStats :: (Int, Int, Double) -> (Int, Int) -> String
formatClosureStats (total, closed, rate) (startYear, endYear) = unlines
  ["", "=" ++ replicate 60 '=',
   "ANALYSIS 3: CASE CLOSURE RATE",
   "=" ++ replicate 60 '=',
   "Time Period: " ++ show startYear ++ " - " ++ show endYear,
   "Total Cases: " ++ show total,
   "Cases Closed: " ++ show closed,
   "Closure Rate: " ++ show (round rate :: Int) ++ "%"]

main :: IO ()
main = do
  putStrLn "\nBaltimore Homicides Analysis Tool"
  putStrLn "By: Tehya Purifoy"
  putStrLn "COSC 352 - Functional Programming\n"
  putStrLn "Loading data...\n"
  
  csvData <- BL.readFile "baltimore_homicides_combined.csv"
  
  case decodeByName csvData of
    Left err -> putStrLn ("Error parsing CSV: " ++ err)
    Right (_, records) -> do
      let homicides = V.toList records
      
      putStrLn ("Loaded " ++ show (length homicides) ++ " homicide records\n")
      
      let yearlyData = homicidesPerYear homicides
      let topLocs = topLocations 10 homicides
      let closureStats = closureAnalysis homicides
      let yearRange = getYearRange homicides
      
      putStrLn (formatYearlyData yearlyData)
      putStrLn (formatTopLocations topLocs)
      putStrLn (formatClosureStats closureStats yearRange)
      
      putStrLn (replicate 62 '=')
      putStrLn "Analysis complete!"
      putStrLn (replicate 62 '=')
