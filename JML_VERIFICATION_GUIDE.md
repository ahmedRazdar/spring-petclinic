# JML (Java Modeling Language) and OpenJML Verification Guide

## 📋 Overview

This project uses **JML (Java Modeling Language)** to provide formal specifications for core methods, and **OpenJML** to verify these specifications. JML annotations document preconditions, postconditions, and invariants that can be mathematically verified.

## 🎯 What is JML?

**JML (Java Modeling Language)** is a behavioral interface specification language for Java. It allows you to formally specify:
- **Preconditions** (`requires`) - What must be true before a method executes
- **Postconditions** (`ensures`) - What must be true after a method executes
- **Invariants** - Properties that must always be true for a class
- **Frame conditions** - What can and cannot be modified

## 📍 JML Annotations in This Project

JML annotations have been added to the following core components:

### **1. OwnerRepository**
- `findByLastNameStartingWith()` - Specifies that results must start with the given last name
- `findById()` - Specifies that returned Optional contains owner with matching ID if present

### **2. VetRepository**
- `findAll()` - Specifies that result is non-null and contains only non-null vets
- `findAll(Pageable)` - Specifies pagination behavior

### **3. Owner Class**
- `addPet()` - Specifies pet addition behavior
- `getPet(String)` - Specifies pet retrieval by name
- `getPet(Integer)` - Specifies pet retrieval by ID
- `addVisit()` - Specifies visit addition to pet

### **4. Pet Class**
- `setBirthDate()`, `getBirthDate()` - Property accessors
- `setType()`, `getType()` - Property accessors
- `getVisits()` - Collection accessor
- `addVisit()` - Visit addition

### **5. PetValidator**
- `validate()` - Specifies validation error conditions
- `supports()` - Specifies class support check

## 🛠️ Setup OpenJML

### **Automatic Setup (Recommended)**

**Linux/macOS:**
```bash
./scripts/setup-openjml.sh
```

**Windows:**
```cmd
scripts\setup-openjml.bat
```

This script will:
1. Download OpenJML from GitHub releases
2. Extract it to `tools/openjml/`
3. Verify the installation

### **Manual Setup**

1. Download OpenJML from: https://github.com/OpenJML/OpenJML/releases
2. Extract to `tools/openjml/`
3. Verify `tools/openjml/openjml.jar` exists

## ✅ Running JML Verification

### **Using Scripts**

**Linux/macOS:**
```bash
./scripts/verify-jml.sh
```

**Windows:**
```cmd
scripts\verify-jml.bat
```

### **Using Maven**

```bash
# Run JML verification during verify phase
./mvnw verify

# Skip JML verification
./mvnw verify -DskipJmlVerification=true

# Run only JML verification
./mvnw exec:exec@verify-jml
```

### **Direct OpenJML Command**

```bash
java -jar tools/openjml/openjml.jar -check \
  -cp "$(./mvnw dependency:build-classpath -q | tail -1)" \
  src/main/java/org/springframework/samples/petclinic/owner/*.java
```

## 📝 JML Syntax Examples

### **Basic Precondition and Postcondition**

```java
/*@
 @ requires parameter != null;
 @ ensures \result != null;
 @*/
public ReturnType method(ParameterType parameter) {
    // Implementation
}
```

### **Quantified Expressions**

```java
/*@
 @ requires lastName != null;
 @ ensures (\forall Owner o; \result.contains(o); 
 @            o.getLastName().startsWith(lastName));
 @*/
public Page<Owner> findByLastNameStartingWith(String lastName) {
    // Implementation
}
```

### **Optional Return Values**

```java
/*@
 @ requires id != null;
 @ ensures \result.isPresent() ==> \result.get().getId().equals(id);
 @ ensures !\result.isPresent() ==> (\forall Owner o; true; o.getId() != id);
 @*/
public Optional<Owner> findById(Integer id) {
    // Implementation
}
```

## 🔍 Understanding JML Keywords

| Keyword | Meaning | Example |
|---------|---------|---------|
| `requires` | Precondition | `requires param != null;` |
| `ensures` | Postcondition | `ensures \result != null;` |
| `\result` | Return value | `ensures \result > 0;` |
| `\old(expr)` | Value before method | `ensures \result == \old(value) + 1;` |
| `\forall` | Universal quantifier | `(\forall int i; 0 <= i < arr.length; arr[i] != null)` |
| `\exists` | Existential quantifier | `(\exists int i; 0 <= i < arr.length; arr[i] == value)` |
| `==>` | Implication | `x != null ==> x.getValue() != null` |
| `<==>` | Biconditional | `x == null <==> y == null` |
| `assignable` | What can be modified | `assignable \nothing;` |

## 🚨 Common JML Verification Issues

### **1. Null Pointer Issues**

**Problem:**
```
Error: Possible null pointer dereference
```

**Solution:** Add null checks in preconditions:
```java
/*@ requires parameter != null; @*/
```

### **2. Quantifier Errors**

**Problem:**
```
Error: Quantifier variable not in scope
```

**Solution:** Ensure quantifier variables are properly scoped:
```java
/*@ ensures (\forall Owner o; \result.contains(o); o != null); @*/
```

### **3. Type Mismatches**

**Problem:**
```
Error: Type mismatch in JML expression
```

**Solution:** Ensure JML expressions match Java types:
```java
/*@ ensures \result instanceof Owner; @*/
```

## 📊 CI/CD Integration

JML verification can be integrated into CI/CD:

```yaml
# .github/workflows/maven-build.yml
- name: Verify JML Specifications
  run: |
    ./scripts/setup-openjml.sh
    ./scripts/verify-jml.sh
  continue-on-error: true  # Don't fail build on JML warnings
```

## 🎓 Learning Resources

- **OpenJML Documentation:** https://www.openjml.org/
- **JML Reference Manual:** https://www.eecs.ucf.edu/~leavens/JML/
- **JML Tutorial:** https://www.openjml.org/documentation/

## 📋 Current Status

✅ **JML Annotations Added:**
- OwnerRepository methods
- VetRepository methods
- Owner class methods
- Pet class methods
- PetValidator methods

✅ **OpenJML Setup:**
- Setup scripts created
- Verification scripts created
- Maven integration configured

⚠️ **Note:** OpenJML verification may produce warnings for complex Spring Data JPA methods due to framework-specific behavior. These are typically safe to ignore for interface methods that are implemented by Spring Data.

## 🔧 Troubleshooting

### **OpenJML Not Found**

```bash
# Re-run setup
./scripts/setup-openjml.sh
```

### **Classpath Issues**

```bash
# Build project first
./mvnw clean compile

# Then run verification
./scripts/verify-jml.sh
```

### **Skip JML Verification**

```bash
# In Maven
./mvnw verify -DskipJmlVerification=true
```

## 📝 Adding New JML Annotations

When adding JML to new methods:

1. **Identify preconditions** - What must be true before execution?
2. **Identify postconditions** - What must be true after execution?
3. **Use appropriate syntax** - Follow JML syntax rules
4. **Test verification** - Run `./scripts/verify-jml.sh` to verify

Example:
```java
/*@
 @ requires input != null && !input.isEmpty();
 @ ensures \result != null;
 @ ensures \result.length() > 0;
 @*/
public String process(String input) {
    return input.trim().toUpperCase();
}
```

---

**Happy Verifying! 🔍**


