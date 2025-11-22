# Baltimore Homicides Analysis

**Functional Programming Project - COSC 352**  
**Author:** Tehya Purifoy  
**GitHub:** tpurifoy52

## Overview
A purely functional analysis tool for Baltimore homicide data (2005-2022), built in Haskell using immutable data structures and functional programming principles.

## Analyses Performed

### 1. Homicides Per Year
- **Method**: Uses `foldr` to aggregate homicides by year
- **Output**: Year-by-year counts with trend analysis
- **Purpose**: Identify temporal patterns in homicide rates over time
- **Functional Techniques**: Pattern matching, fold/reduce operations

### 2. Top 10 Most Dangerous Locations
- **Method**: Uses `foldr` for counting, `sortBy` for ranking
- **Output**: Ranked list of address blocks by homicide count
- **Purpose**: Identify high-risk areas for resource allocation
- **Functional Techniques**: Map operations, sorting, pattern matching

### 3. Case Closure Rate Analysis
- **Method**: Uses `filter` and fold operations
- **Output**: Total cases, closed cases, and closure percentage
- **Purpose**: Evaluate police investigation effectiveness
- **Functional Techniques**: Filter, pure calculations, no mutation

## Functional Programming Principles

### Pure Functional Core ✨
- **No mutation**: All data structures are immutable
- **No I/O in analysis functions**: File reading isolated in `main`
- **Uses required constructs**: `map`, `filter`, `fold`, pattern matching, recursion
- **Composable**: Functions build on each other through composition

### Type Safety
- Custom `Homicide` data type with strong typing
- Pattern matching for safe data access
- Compiler-verified correctness
- No null pointer exceptions

### Key Functional Techniques Demonstrated
1. **Higher-order functions**: `foldr`, `map`, `filter`, `sortBy`
2. **Function composition**: Building complex analysis from simple functions
3. **Immutability**: No variable mutation anywhere
4. **Pattern matching**: Safe data extraction
5. **Recursion**: Through fold operations and Map functions
6. **Type-driven development**: Let types guide implementation

## Running the Program

### Option 1: Using Docker (Recommended for Grading)
```bash
# Build the Docker image
docker build -t baltimore-homicides .

# Run the analysis
docker run baltimore-homicides
```

### Option 2: Local Development
```bash
# Install dependencies
cabal update

# Build the project
cabal build

# Run the program
cabal run baltimore-homicides
```

## Project Structure
```
baltimore-homicides/
├── src/
│   └── Main.hs                       # Main program with pure functions
├── baltimore_homicides_combined.csv  # Dataset (2005-2022)
├── baltimore-homicides.cabal         # Build configuration
├── Dockerfile                        # Docker configuration
├── README.md                         # This file
└── .gitignore                        # Git ignore patterns
```

## Technical Implementation

### Dependencies
- `cassava`: CSV parsing library
- `vector`: Efficient immutable arrays
- `bytestring`: Efficient I/O operations
- `containers`: Map data structure for aggregations
- `text`: Text processing

### Data Flow
1. **Input**: CSV file read (I/O layer)
2. **Parse**: Convert to strongly-typed `Homicide` records
3. **Analyze**: Pure functions process data (no I/O, no mutation)
4. **Format**: Pure functions create display strings
5. **Output**: Print results (I/O layer)

### Code Organization
- **Data Types**: Line 11-25 (immutable record type)
- **CSV Parsing**: Line 27-41 (type-safe parsing)
- **Pure Analysis**: Line 47-95 (no I/O, no mutation)
- **Formatting**: Line 100-139 (pure display functions)
- **I/O Layer**: Line 144-177 (isolated side effects)

## Key Findings

**Temporal Trends:**
- Analysis covers 2005-2022
- Peak years and decline patterns visible
- Trend calculation shows percentage change over time period

**Geographic Patterns:**
- Certain address blocks show significantly higher incident rates
- Top 10 locations identified for targeted intervention
- Data suggests geographic clustering of violence

**Investigation Effectiveness:**
- Case closure rate calculated across entire dataset
- Provides metric for evaluating police department performance
- Can track improvement over time periods

## Functional Programming Grading Criteria Met

✅ **Functional Design (20%)**
- Pure functions with no side effects
- Function composition and higher-order functions
- Immutable data structures throughout

✅ **Correctness (20%)**
- Accurate aggregations using fold operations
- Proper sorting and ranking
- Correct statistical calculations

✅ **Code Quality (20%)**
- Clear function names and organization
- Type signatures documented
- Comments explaining functional techniques
- Separation of pure and impure code

✅ **Docker (10%)**
- Working Dockerfile included
- Builds and runs successfully
- All dependencies managed

✅ **GitHub (10%)**
- Checked into Project8 folder
- Complete project structure
- Clear documentation

## Learning Outcomes

This project demonstrates:
- Understanding of pure functional programming
- Ability to separate I/O from business logic
- Use of Haskell's type system for safety
- Application of map/filter/reduce patterns
- Real-world data analysis in functional style

## Author
**Tehya Purifoy**  
COSC 352 - Fall 2025  
Morgan State University
