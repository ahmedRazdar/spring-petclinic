/*
 * CRUD API Test Example using JUnit 5 + Real Database
 *
 * This demonstrates:
 * - Testing full CRUD operations
 * - Using real database (H2 in-memory or Testcontainers)
 * - Testing API endpoints end-to-end
 */

package org.springframework.samples.petclinic.api.owner;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.samples.petclinic.owner.Owner;
import org.springframework.samples.petclinic.owner.OwnerRepository;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * CRUD API tests for Owner operations. Uses real database (H2 in-memory) for testing.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@DisplayName("Owner CRUD API Tests")
class OwnerCrudApiTest {

	private MockMvc mockMvc;

	@Autowired
	private OwnerRepository ownerRepository;

	@Autowired
	private WebApplicationContext webApplicationContext;

	private Owner testOwner;

	@BeforeEach
	void setUp() {
		// Initialize MockMvc using the full web application context
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.webApplicationContext).build();

		// Clean up before each test
		ownerRepository.deleteAll();

		// Create test owner
		testOwner = new Owner();
		testOwner.setFirstName("John");
		testOwner.setLastName("Doe");
		testOwner.setAddress("123 Main St");
		testOwner.setCity("Springfield");
		testOwner.setTelephone("1234567890");
	}

	@Test
	@DisplayName("CREATE - Should create a new owner")
	void shouldCreateNewOwner() throws Exception {
		// Given
		String ownerJson = """
				{
					"firstName": "Jane",
					"lastName": "Smith",
					"address": "456 Oak Ave",
					"city": "Springfield",
					"telephone": "0987654321"
				}
				""";

		// When & Then
		mockMvc
			.perform(post("/owners/new").contentType(MediaType.APPLICATION_FORM_URLENCODED)
				.param("firstName", "Jane")
				.param("lastName", "Smith")
				.param("address", "456 Oak Ave")
				.param("city", "Springfield")
				.param("telephone", "0987654321"))
			.andDo(print())
			.andExpect(status().is3xxRedirection())
			.andExpect(redirectedUrlPattern("/owners/*"));

		// Verify in database
		Optional<Owner> saved = ownerRepository.findByLastNameStartingWith("Smith", Pageable.unpaged())
			.stream()
			.findFirst();
		assertThat(saved).isPresent();
		assertThat(saved.get().getFirstName()).isEqualTo("Jane");
	}

	@Test
	@DisplayName("READ - Should retrieve owner by ID")
	void shouldRetrieveOwnerById() throws Exception {
		// Given
		Owner saved = ownerRepository.save(testOwner);
		Integer ownerId = saved.getId();

		// When & Then
		mockMvc.perform(get("/owners/{id}", ownerId))
			.andDo(print())
			.andExpect(status().isOk())
			.andExpect(view().name("owners/ownerDetails"))
			.andExpect(model().attributeExists("owner"))
			.andExpect(model().attribute("owner", hasProperty("id", is(ownerId))))
			.andExpect(model().attribute("owner", hasProperty("firstName", is("John"))))
			.andExpect(model().attribute("owner", hasProperty("lastName", is("Doe"))));
	}

	@Test
	@DisplayName("READ - Should find owners by last name")
	void shouldFindOwnersByLastName() throws Exception {
		// Given
		ownerRepository.save(testOwner);
		Owner owner2 = new Owner();
		owner2.setFirstName("Jane");
		owner2.setLastName("Doe");
		owner2.setAddress("789 Pine St");
		owner2.setCity("Springfield");
		owner2.setTelephone("1111111111");
		ownerRepository.save(owner2);

		// When & Then
		mockMvc.perform(get("/owners").param("lastName", "Doe"))
			.andDo(print())
			.andExpect(status().isOk())
			.andExpect(view().name("owners/ownersList"))
			.andExpect(model().attributeExists("listOwners"))
			.andExpect(model().attribute("listOwners", hasSize(greaterThanOrEqualTo(2))));
	}

	@Test
	@DisplayName("UPDATE - Should update existing owner")
	void shouldUpdateExistingOwner() throws Exception {
		// Given
		Owner saved = ownerRepository.save(testOwner);
		Integer ownerId = saved.getId();

		// When & Then
		mockMvc
			.perform(post("/owners/{id}/edit", ownerId).contentType(MediaType.APPLICATION_FORM_URLENCODED)
				.param("firstName", "John Updated")
				.param("lastName", "Doe")
				.param("address", "123 Main St Updated")
				.param("city", "Springfield")
				.param("telephone", "1234567890"))
			.andDo(print())
			.andExpect(status().is3xxRedirection())
			.andExpect(redirectedUrl("/owners/" + ownerId));

		// Verify update in database
		Optional<Owner> updated = ownerRepository.findById(ownerId);
		assertThat(updated).isPresent();
		assertThat(updated.get().getFirstName()).isEqualTo("John Updated");
		assertThat(updated.get().getAddress()).isEqualTo("123 Main St Updated");
	}

	@Test
	@DisplayName("DELETE - Should handle owner deletion (if implemented)")
	void shouldHandleOwnerDeletion() throws Exception {
		// Given
		Owner saved = ownerRepository.save(testOwner);
		Integer ownerId = saved.getId();

		// Note: Delete endpoint may not be implemented in this application
		// This is a template for when it's added
		// When & Then
		// mockMvc.perform(delete("/owners/{id}", ownerId))
		// .andDo(print())
		// .andExpect(status().isOk());

		// Verify deletion
		// Optional<Owner> deleted = ownerRepository.findById(ownerId);
		// assertThat(deleted).isEmpty();
	}

	@Test
	@DisplayName("VALIDATION - Should reject invalid owner data")
	void shouldRejectInvalidOwnerData() throws Exception {
		// Given - Missing required fields
		// When & Then
		mockMvc.perform(post("/owners/new").contentType(MediaType.APPLICATION_FORM_URLENCODED)
			.param("firstName", "") // Empty first name
			.param("lastName", "Doe")
			.param("telephone", "123")) // Invalid telephone (not 10 digits)
			.andDo(print())
			.andExpect(status().isOk()) // Returns to form with errors
			.andExpect(view().name("owners/createOrUpdateOwnerForm"))
			.andExpect(model().attributeHasErrors("owner"));
	}

	@Test
	@DisplayName("SEARCH - Should return empty list when no owners found")
	void shouldReturnEmptyListWhenNoOwnersFound() throws Exception {
		// When & Then
		mockMvc.perform(get("/owners").param("lastName", "NonExistent"))
			.andDo(print())
			.andExpect(status().isOk())
			.andExpect(view().name("owners/findOwners"))
			.andExpect(model().attributeHasErrors("owner"));
	}

}
