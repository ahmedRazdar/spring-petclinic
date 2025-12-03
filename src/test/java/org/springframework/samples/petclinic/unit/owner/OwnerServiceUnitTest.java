/*
 * Unit Test Example using JUnit 5 + Mockito
 * 
 * This demonstrates proper unit testing with:
 * - Mocking dependencies
 * - Testing business logic in isolation
 * - Verifying interactions
 */

package org.springframework.samples.petclinic.unit.owner;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.samples.petclinic.owner.Owner;
import org.springframework.samples.petclinic.owner.OwnerRepository;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.BDDMockito.then;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

/**
 * Unit test example for Owner-related operations.
 * Uses Mockito to mock the repository dependency.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Owner Service Unit Tests")
class OwnerServiceUnitTest {

	@Mock
	private OwnerRepository ownerRepository;

	// Note: In a real application, you would inject a service here
	// For this example, we're testing repository interactions directly

	private Owner testOwner;
	private Pageable pageable;

	@BeforeEach
	void setUp() {
		testOwner = new Owner();
		testOwner.setId(1);
		testOwner.setFirstName("John");
		testOwner.setLastName("Doe");
		testOwner.setAddress("123 Main St");
		testOwner.setCity("Springfield");
		testOwner.setTelephone("1234567890");

		pageable = PageRequest.of(0, 5);
	}

	@Test
	@DisplayName("Should find owner by ID")
	void shouldFindOwnerById() {
		// Given
		Integer ownerId = 1;
		given(ownerRepository.findById(ownerId)).willReturn(Optional.of(testOwner));

		// When
		Optional<Owner> result = ownerRepository.findById(ownerId);

		// Then
		assertThat(result).isPresent();
		assertThat(result.get().getId()).isEqualTo(ownerId);
		assertThat(result.get().getFirstName()).isEqualTo("John");
		verify(ownerRepository, times(1)).findById(ownerId);
	}

	@Test
	@DisplayName("Should return empty when owner not found")
	void shouldReturnEmptyWhenOwnerNotFound() {
		// Given
		Integer ownerId = 999;
		given(ownerRepository.findById(ownerId)).willReturn(Optional.empty());

		// When
		Optional<Owner> result = ownerRepository.findById(ownerId);

		// Then
		assertThat(result).isEmpty();
		verify(ownerRepository, times(1)).findById(ownerId);
	}

	@Test
	@DisplayName("Should find owners by last name with pagination")
	void shouldFindOwnersByLastNameWithPagination() {
		// Given
		String lastName = "Doe";
		List<Owner> owners = Arrays.asList(testOwner);
		Page<Owner> page = new PageImpl<>(owners, pageable, 1);
		given(ownerRepository.findByLastNameStartingWith(anyString(), any(Pageable.class)))
			.willReturn(page);

		// When
		Page<Owner> result = ownerRepository.findByLastNameStartingWith(lastName, pageable);

		// Then
		assertThat(result).isNotNull();
		assertThat(result.getContent()).hasSize(1);
		assertThat(result.getContent().get(0).getLastName()).isEqualTo("Doe");
		verify(ownerRepository, times(1)).findByLastNameStartingWith(lastName, pageable);
	}

	@Test
	@DisplayName("Should save owner")
	void shouldSaveOwner() {
		// Given
		Owner newOwner = new Owner();
		newOwner.setFirstName("Jane");
		newOwner.setLastName("Smith");
		given(ownerRepository.save(any(Owner.class))).willReturn(testOwner);

		// When
		Owner saved = ownerRepository.save(newOwner);

		// Then
		assertThat(saved).isNotNull();
		assertThat(saved.getId()).isEqualTo(1);
		verify(ownerRepository, times(1)).save(newOwner);
	}

	@Test
	@DisplayName("Should not save when owner is null")
	void shouldNotSaveWhenOwnerIsNull() {
		// When/Then
		assertThatThrownBy(() -> ownerRepository.save(null))
			.isInstanceOf(Exception.class);
		verify(ownerRepository, never()).save(any(Owner.class));
	}

	@Test
	@DisplayName("Should verify repository interactions")
	void shouldVerifyRepositoryInteractions() {
		// Given
		given(ownerRepository.findById(1)).willReturn(Optional.of(testOwner));

		// When
		ownerRepository.findById(1);
		ownerRepository.findById(1);

		// Then
		then(ownerRepository).should(times(2)).findById(1);
		then(ownerRepository).should(never()).delete(any());
	}

}

